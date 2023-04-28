//
//  ContentView.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
import WeatherKit

struct ContentView: View {
    
    @Environment(\ .colorScheme)var colorScheme
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var weatherData = WeatherData()
    @State private var attribution: WeatherAttribution?

    var body: some View {
        VStack {
            Section {
                Spacer()
                VStack(alignment: .center) {
                    CurrentWeatherCell(_city: weatherData.locationManager.city,
                                       _currentWeather: weatherData.currentWeather,
                                       _dailyForecast: weatherData.dailyForecast)
                    HourlyForecastCell(_hourlyForecast: weatherData.hourlyForecast)
                    DailyForecastCell(_dailyForecast: weatherData.dailyForecast)
                }
                Spacer()
            }
            Spacer(minLength: 0)
            AttributionInfoCell(_colorScheme: colorScheme,
                                _attributionInfo: attribution)
        }
        .edgesIgnoringSafeArea(.bottom)
        .task {
            Task {
                attribution =  try await WeatherService.shared.attribution
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                weatherData.cityObserver?.cancel()
                weatherData.getForcast()
            } else if phase == .background {
                weatherData.cityObserver?.cancel()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
