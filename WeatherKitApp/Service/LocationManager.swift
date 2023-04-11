//
//  LocationManager.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import Foundation
import CoreLocation
import WeatherKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var city: String = ""
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: Forecast<DayWeather>?
    @Published var hourlyForecast: Forecast<HourWeather>?
    @Published var attributionInfo: WeatherAttribution?
    
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 100
        manager.startUpdatingLocation()
    }
    
    init(accuracy: CLLocationAccuracy) {
        super.init()
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.desiredAccuracy = accuracy
        self.manager.distanceFilter = 2
        self.manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [self](placemarks, error) in
                    
            if let error = error {
                CommonFunc.shared.logput(error.localizedDescription)
                return
            }

            if let _city = placemarks?.first?.locality {
                if city != _city {
                    city = _city
                    Task.detached { @MainActor in
                        self.attributionInfo =  await WeatherData.shared.attributionInfoData()
                        let forcast = await WeatherData.shared.weatherForecast(userLocation: location)
                        self.currentWeather = forcast.0
                        self.hourlyForecast = forcast.1
                        self.dailyForecast = forcast.2
                    }
                }
            }
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        CommonFunc.shared.logput(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways ||
           manager.authorizationStatus == .authorizedWhenInUse {
            self.manager.requestLocation()
        }
    }
}
