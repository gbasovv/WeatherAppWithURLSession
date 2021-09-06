//
//  ViewController.swift
//  WeatherApp
//
//  Created by George on 4.09.21.
//

import UIKit
import CoreLocation
import CoreData

class WeatherVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var feelsLikeLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!

    @IBOutlet var table: UITableView!

    var city = ""
    var weatherResult: Result?
    var weatherHourly: [Hourly] = []
    var weatherDaily: [Daily] = []
    var currentParam: Current?
    var locationManger = CLLocationManager()
    var currentLocation: CLLocation?

    var currentWeather = [CurrentWeather]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
        loadData()
        getLocation()
        table.register(HourlyTVC.nib(), forCellReuseIdentifier: HourlyTVC.identifier)
        table.register(DailyTVC.nib(), forCellReuseIdentifier: DailyTVC.identifier)
        table.register(CurrentParamCell.nib(), forCellReuseIdentifier: CurrentParamCell.identifier)
        table.delegate = self
        table.dataSource = self
    }

    func getLocation() {
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManger.stopUpdatingLocation()
        }
        guard let currentLocation = currentLocation else { return }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude

        self.currentLocation = currentLocation

        NetworkService.shared.setLatitude(lat)
        NetworkService.shared.setLongitude(long)

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placemark = placemarks[0]
                    if let city = placemark.locality {
                        self.city = city
                    }
                }
            }
        }

        getWeather()

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }

    func getWeather() {
        NetworkService.shared.getWeather(onSuccess: { (result) in
            self.weatherResult = result

            self.weatherResult?.sortDailyArray()
            self.weatherResult?.sortHourlyArray()

            self.weatherHourly = result.hourly
            self.weatherDaily = result.daily
            self.currentParam = result.current

            let newCurrentWeather = CurrentWeather(context: self.context)
            newCurrentWeather.cityName = self.city
            newCurrentWeather.temperature = result.current.temp
            newCurrentWeather.descriptionWeather = result.current.weather[0].description
            self.currentWeather.append(newCurrentWeather)
            self.saveData()

            self.updateViews()
            self.table.reloadData()

        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }

    func updateViews() {
        if weatherResult == nil {
            cityLbl.text = currentWeather[0].cityName
            descriptionLbl.text = currentWeather[0].descriptionWeather
            tempLbl.text = "\(Int(currentWeather[0].temperature))"
        }
        cityLbl.text = city
        descriptionLbl.text = weatherResult?.current.weather[0].description.capitalized
        tempLbl.text = "\(Int((weatherResult?.current.temp)!))°F"
        feelsLikeLbl.text = "Feels like \(Int((weatherResult?.current.feels_like)!))°F"
        weatherImage.image = UIImage(named: (weatherResult?.current.weather[0].icon)!)
    }

    func clearAll() {
        cityLbl.text = ""
        descriptionLbl.text = ""
        tempLbl.text = ""
        feelsLikeLbl.text = ""
        weatherImage.image = nil
    }


}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return weatherDaily.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTVC.identifier, for: indexPath) as! HourlyTVC
            cell.configure(with: weatherHourly)
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyTVC.identifier, for: indexPath) as! DailyTVC
            cell.configure(with: weatherDaily[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentParamCell.identifier, for: indexPath) as! CurrentParamCell
        cell.configure(with: currentParam)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        if indexPath.section == 1 {
            return 44
        }
        return 341
    }
}

extension WeatherVC {

    func loadData(with request: NSFetchRequest<CurrentWeather> = CurrentWeather.fetchRequest()) {
        do {
            currentWeather = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        table.reloadData()
    }

    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

