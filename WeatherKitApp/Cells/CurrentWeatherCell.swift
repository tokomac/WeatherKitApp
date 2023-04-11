//
//  CurrentWeatherCell.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
import WeatherKit

struct CurrentWeatherCell: View {
    
    let city: String
    let currentWeather: CurrentWeather?
    let dailyForecast: Forecast<DayWeather>?
    
    // MARK: - Initialization
    init(
        _city: String = "",
        _currentWeather: CurrentWeather? = nil,
        _dailyForecast: Forecast<DayWeather>? = nil
    ) {
        self.city = _city
        self.currentWeather = _currentWeather
        self.dailyForecast = _dailyForecast
    }
    
    // MARK: - View
    var body: some View {
        if let currentWeather = currentWeather,
           let dailyForecast = dailyForecast {
            Text(city)
                .font(.system(.largeTitle))
            Text("\(CommonFunc.shared.temperatureString(temp: currentWeather.temperature.value))")
                .font(.system(.largeTitle))
            Spacer()
            Text(currentWeather.condition.description)
                .font(.system(.title2))
            Spacer()
            if let dayWeather = dailyForecast.first {
                HStack {
                    Label("\(CommonFunc.shared.temperatureString(temp: dayWeather.highTemperature.value))", systemImage: "thermometer.high")
                    Label("\(CommonFunc.shared.temperatureString(temp: dayWeather.lowTemperature.value))", systemImage: "thermometer.low")
                }
                .font(.system(.title2))
            }
            Spacer()
        }
    }
}
