//
//  DailyForecastCell.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
import WeatherKit

struct DailyForecastCell: View {
    
    let dailyForecast: Forecast<DayWeather>?
    
    // MARK: - Initialization
    init(
        _dailyForecast: Forecast<DayWeather>? = nil
    ) {
        self.dailyForecast = _dailyForecast
    }

    // MARK: - View
    var body: some View {
        if let dailyForecast = dailyForecast {
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(dailyForecast, id: \.self.date) { weatherEntry in
                        HStack(spacing: 5) {
                            Text(weatherEntry.date.stringDate())
                                .frame(width:70,height: 30, alignment: .leading)
                            Image(systemName: weatherEntry.symbolName)
                                .frame(width:40,height: 30, alignment: .center)
                            Label("\(CommonFunc.shared.temperatureString(temp: weatherEntry.highTemperature.value))", systemImage: "thermometer.high")
                                .frame(width:80,height: 30, alignment: .leading)
                            Label("\(CommonFunc.shared.temperatureString(temp: weatherEntry.lowTemperature.value))", systemImage: "thermometer.low")
                                .frame(width:80,height: 30, alignment: .leading)
                            Label("\(CommonFunc.shared.precipitationString(precipitation: weatherEntry.precipitationChance))", systemImage: "umbrella.percent.fill")
                                .frame(width:80,height: 30, alignment: .trailing)
                        }
                        .padding(3)
                        .font(.system(.caption, design: .monospaced))
                    }
                }
            }
        }
    }
}

