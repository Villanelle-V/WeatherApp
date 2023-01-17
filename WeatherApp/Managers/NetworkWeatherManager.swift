//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by Polina on 2022-10-16.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitide: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCopletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(for requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitide, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitide)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        perfomRequest(with: urlString)
    }
    
    func perfomRequest(with urlString: String) {
                guard let url = URL(string: urlString) else { return }
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, response, error in
                    if let data = data {
                        if let currentWeather = self.parseJSON(withData: data) {
                            self.onCopletion?(currentWeather)
                        }
                    }
                }
                task.resume()
    }
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        return nil
    }
}
