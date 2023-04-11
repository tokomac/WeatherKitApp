//
//  ShareService.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import Foundation
import WeatherKit

class CommonFunc {
    
    static let shared = CommonFunc()
    
    var localeId: String {
        return Locale.preferredLanguages.first!
    }
    
    func localeValue(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    func temperatureString(temp: Double) -> String {
        let temperatureMeasurement = Measurement<UnitTemperature>(value: temp.rounded(.toNearestOrAwayFromZero), unit: .celsius)
        return temperatureMeasurement.formatted(.measurement(width: .narrow, usage: .weather))
    }
    
    func precipitationString(precipitation: Double) -> String {
        let precipitation = String(format: "%3d", Int((precipitation * 10).rounded(.toNearestOrAwayFromZero)*10))
        return "\(precipitation)%"
    }
    
    func logput(_ items: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        var array: [Any] = ["**Log: \(fileName)", "Line:\(line)", function]
        array.append(contentsOf: items)
        Swift.print(array)
        #endif
    }
}
