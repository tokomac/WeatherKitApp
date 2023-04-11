//
//  ContentView.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
//import WeatherKit

struct ContentView: View {
    
    @Environment(\ .colorScheme)var colorScheme
    @ObservedObject private var locationManager = LocationManager()
    
//    @State private var attributionInfo: WeatherAttribution?

    var body: some View {
        VStack {
            Section {
                Spacer()
                VStack(alignment: .center) {
                    CurrentWeatherCell(_city: locationManager.city,
                                       _currentWeather: locationManager.currentWeather,
                                       _dailyForecast: locationManager.dailyForecast)
                    HourlyForecastCell(_hourlyForecast: locationManager.hourlyForecast)
                    DailyForecastCell(_dailyForecast: locationManager.dailyForecast)
                }
                Spacer()
            }
            Spacer(minLength: 0)
            AttributionInfoCell(_colorScheme: colorScheme,
                                _attributionInfo: locationManager.attributionInfo)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
