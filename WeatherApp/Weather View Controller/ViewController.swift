//
//  ViewController.swift
//  WeatherApp
//
//  Created by Polina on 2022-10-14.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLbel: UILabel!
    
    var networkManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.onCopletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
            }
        }
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.presentSearchAlertController(with: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkManager.fetchCurrentWeather(for: .cityName(city: city))
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLbel.text = weather.temparetureString
            self.feelsLikeLabel.text = weather.feelsLikeTemparetureString
            self.humidityLabel.text = weather.humidityString
            self.weatherLabel.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}


// MARK: - CLLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkManager.fetchCurrentWeather(for: .coordinate(latitide: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

