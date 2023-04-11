//
//  WeatherData.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherData {
    
    static let shared = WeatherData()
    private let service = WeatherService.shared
    
    func attributionInfoData() async -> WeatherAttribution?  {
        let _attributionInfo = await Task.detached(priority: .userInitiated) {
            let _attribution = try? await self.service.attribution
            return _attribution
        }.value
        return _attributionInfo
    }
    
    func weatherForecast(userLocation: CLLocation) async -> (CurrentWeather?, Forecast<HourWeather>?, Forecast<DayWeather>?) {
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
