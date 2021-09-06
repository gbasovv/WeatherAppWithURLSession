//
//  NetworkService.swift
//  WeatherApp
//
//  Created by George on 5.09.21.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    let url = "https://api.openweathermap.org/data/2.5/onecall?lat=60.99&lon=30.9&appid=89575d3c850c4fe09a01e9aedf6aec9e"
    let apiKey = "bc5b9ab7d0359c41defa85ade1627c8d"
    var urlLat = "60.99"
    var urlLon = "30.0"
    var urlGetOneCall = ""
    let urlBase = "https://api.openweathermap.org/data/2.5"
    
    let session = URLSession(configuration: .default)
    
    func buildURL() -> String {
        urlGetOneCall = "/onecall?lat=" + urlLat + "&lon=" + urlLon + "&units=imperial" + "&appid=" + apiKey
        return urlBase + urlGetOneCall
    }
    
    func setLatitude(_ latitude: String) {
        urlLat = latitude
    }
    
    func setLatitude(_ latitude: Double) {
        setLatitude(String(latitude))
    }
    
    func setLongitude(_ longitude: String) {
        urlLon = longitude
    }
    
    func setLongitude(_ longitude: Double) {
        setLongitude(String(longitude))
    }
    
    func getWeather(onSuccess: @escaping (Result) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildURL()) else {
            onError("Error building URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(Result.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
}
