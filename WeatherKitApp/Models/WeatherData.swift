//
//  WeatherData.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
import WeatherKit
import CoreLocation
import Combine

class WeatherData: ObservableObject {
    
    static let shared = WeatherData()
    private let service = WeatherService.shared
    var cityObserver: AnyCancellable?
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: Forecast<DayWeather>?
    @Published var hourlyForecast: Forecast<HourWeather>?
    @ObservedObject var locationManager: LocationManager = LocationManager()
    
    deinit {
        cityObserver?.cancel()
    }
    
    init() {
        getForcast()
    }
    
    func getForcast() {
        cityObserver = locationManager.$location.receive(on: DispatchQueue.main)
            .sink { _loc in
                Task.detached { @MainActor in
                    if let _location = _loc {
                        let forcast = await WeatherData.shared.weatherForecast(userLocation: _location)
                        self.currentWeather = forcast.0
                        self.hourlyForecast = forcast.1
                        self.dailyForecast = forcast.2
                    }
                }
            }
    }
 
    private func weatherForecast(userLocation: CLLocation) async -> (CurrentWeather?, Forecast<HourWeather>?, Forecast<DayWeather>?) {
        let _forecast = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: userLocation,
                including: .current, .hourly, .daily)
            return forcast
        }.value
        if let forecast = _forecast {
            return forecast
        }
        return (nil, nil, nil)
    }
}
