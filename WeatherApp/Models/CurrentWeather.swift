//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Polina on 2022-10-17.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    let temperature: Double
    var temparetureString: String {
        return String(format: "%0.f", temperature) + "˚C"
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemparetureString: String {

        return "feels like: " + String(format: "%.0f", feelsLikeTemperature) + "˚C"
    }
    
    let humidity: Int
    var humidityString: String {
        return "humidity: \(humidity)%"
    }
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        humidity = currentWeatherData.main.humidity
        conditionCode = currentWeatherData.weather.first!.id
    }
}
