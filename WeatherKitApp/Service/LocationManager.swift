//
//  LocationManager.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var city: String = ""
    @Published var location: CLLocation?
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 100
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let _location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(_location) { [self](_placemarks, _error) in

            if let error = _error {
                CommonFunc.shared.logput(error.localizedDescription)
                return
            }
            guard let _city = _placemarks?.first?.locality else { return }

            if _city != city {
                city = _city
                location = _location
                CommonFunc.shared.logput(city)
            }
        }
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
