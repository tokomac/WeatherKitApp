//
//  Extensions.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import Foundation

extension Date {
    
    func stringTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale(identifier: CommonFunc.shared.localeId))
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d MMM", options: 0, locale: Locale(identifier: CommonFunc.shared.localeId))
        return dateFormatter.string(from: self)
    }
}
