//
//  AttributionInfoCell.swift
//  WeatherKitApp
//
//  Created by tokomac on 2023/04/09.
//

import SwiftUI
import WeatherKit

struct AttributionInfoCell: View {
    
    let colorScheme: ColorScheme
    let attributionInfo: WeatherAttribution?
    
    // MARK: - Initialization
    init(
        _colorScheme: ColorScheme,
        _attributionInfo: WeatherAttribution?
    ) {
        self.colorScheme = _colorScheme
        self.attributionInfo = _attributionInfo
    }
    
    // MARK: - View
    var body: some View {
        HStack {
            Spacer()
            VStack {
                if let attribution = attributionInfo {
                    AsyncImage(url: colorScheme == .dark ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL) { result in
                        if let image = result.image {
                            image.resizable().scaledToFit().frame(height: 20)
                        } else if result.error != nil {
                            Text(result.error!.localizedDescription)
                        } else {
                            ProgressView()
                        }
                    }
                    Link("Other data sources", destination: attribution.legalPageURL)
                }
            }
            Spacer()
        }
        .padding(.all)
        .font(.headline)
    }
}
