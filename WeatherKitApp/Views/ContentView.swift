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
    @StateObject private var weatherData = WeatherData()
    @State private var attribution: WeatherAttribution?

    var body: some View {
        VStack {
            Section {
                Spacer()
                if weatherData.errorMessage != "" {
                    Text(weatherData.errorMessage)
                        .font(.title2)
                }
                VStack(alignment: .center) {
                    CurrentWeatherCell(weatherData.locationManager.city,
                                       weatherData.currentWeather,
                                       weatherData.dailyForecast)
                    HourlyForecastCell(weatherData.hourlyForecast)
                    DailyForecastCell(weatherData.dailyForecast)
                }
                Spacer()
            }
            Spacer(minLength: 0)
            AttributionInfoCell(colorScheme, attribution)
        }
        .edgesIgnoringSafeArea(.bottom)
        .task {
            Task {
                attribution =  try await WeatherService.shared.attribution
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
//                weatherData.deactivate()
                weatherData.locationManager.activate()
                weatherData.activate()
            } else if phase == .background {
                weatherData.locationManager.deactivate()
                weatherData.deactivate()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
