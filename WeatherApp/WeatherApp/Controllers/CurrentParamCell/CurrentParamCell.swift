//
//  CurrentParamCell.swift
//  WeatherApp
//
//  Created by George on 5.09.21.
//

import UIKit

class CurrentParamCell: UITableViewCell {

    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var cloudinessLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var feelsLikeLbl: UILabel!
    @IBOutlet weak var dewPointLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var uviLbl: UILabel!

    static let identifier = "CurrentParamCell"

    static func nib() -> UINib {
        return UINib(nibName: "CurrentParamCell",
            bundle: nil)
    }

    func configure(with model: Current?) {
        guard let model = model else { return }

        self.sunriseLbl.text = getTime(date: model.sunrise)

        self.sunsetLbl.text = getTime(date: model.sunset)

        self.cloudinessLbl.text = "\(model.clouds) %"
        self.humidityLbl.text = "\(model.humidity) %"
        self.windLbl.text = "\(Int(model.wind_speed)) km/h"
        self.feelsLikeLbl.text = "\(Int(model.feels_like)) °F"
        self.dewPointLbl.text = "\(Int(model.dew_point)) cm"
        self.pressureLbl.text = "\(model.pressure) hPa"
        self.tempLbl.text = "\(Int(model.temp)) °F"
        self.uviLbl.text = "\(Int(model.uvi))"
    }

    func getTime(date: Int) -> String {
        let unixTime = NSDate(timeIntervalSince1970: TimeInterval(date))
        let dateString = "\(unixTime)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from: dateString)
        guard let dateObj = dateObj else { return "" }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateObj)
    }
}
