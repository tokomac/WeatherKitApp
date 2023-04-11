//
//  HourlyForecastCell.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
import WeatherKit

struct HourlyForecastCell: View {
    
    let hourlyForecast: Forecast<HourWeather>?
    
    // MARK: - Initialization
    init(
        _hourlyForecast: Forecast<HourWeather>? = nil
    ) {
        self.hourlyForecast = _hourlyForecast
    }
    
    // MARK: - View
    var body: some View {
        if let hourlyForecast = hourlyForecast {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    let subtractTime = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
                    ForEach(hourlyForecast.forecast.filter({ $0.date >= subtractTime }).prefix(25), id: \.self.date) { weatherEntry in
                        VStack(spacing: 5) {
                            Text(weatherEntry.date.stringDate())
                            Text(weatherEntry.date.stringTime())
                            Image(systemName: weatherEntry.symbolName)
                            Text("\(CommonFunc.shared.temperatureString(temp: weatherEntry.temperature.value))")
                            Label("\(CommonFunc.shared.precipitationString(precipitation: weatherEntry.precipitationChance))", systemImage: "umbrella.percent.fill")
                        }
                        .font(.system(.subheadline))
                    }
                }
            }
            .padding(.all)
        }
    }
}
