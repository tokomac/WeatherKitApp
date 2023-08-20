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
    
    private let service = WeatherService.shared
    private var cityObserver: AnyCancellable?
    @Published var errorMessage: String = ""
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: Forecast<DayWeather>?
    @Published var hourlyForecast: Forecast<HourWeather>?
    @ObservedObject var locationManager = LocationManager.shared
    
    func activate() {
        cityObserver = locationManager.$location.receive(on: DispatchQueue.main)
            .sink { _location in
                Task {
                    if let _location = _location {
                        let _resulet = await self.weatherForecast(userLocation: _location)
                        switch _resulet {
                        case .success(let _forecast):
                            self.currentWeather = _forecast.0
                            self.hourlyForecast = _forecast.1
                            self.dailyForecast = _forecast.2
                            self.errorMessage = ""
                        case .failure(let _error):
                            switch _error {
                            case .failure:
                                self.errorMessage = "Failure."
                            }
                        }
                    }
                }
            }
    }
    
    func deactivate() {
        cityObserver?.cancel()
    }
    
    private func weatherForecast(userLocation: CLLocation) async -> Result<(CurrentWeather?, Forecast<HourWeather>?, Forecast<DayWeather>?), WeatherError> {
        let _forecast = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: userLocation,
                including: .current, .hourly, .daily)
            return forcast
        }.value
        if let forecast = _forecast {
            return .success(forecast)
        }
        return .failure(.failure)
    }
}

enum WeatherError : Error {
    case failure
}
