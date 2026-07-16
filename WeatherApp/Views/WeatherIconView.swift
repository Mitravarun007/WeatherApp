//
//  WeatherIconView.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import SwiftUI

struct WeatherIconView: View {
    let iconCode: String
    let size: CGFloat
    
    // Map OpenWeatherMap icon codes to SF Symbols
    var iconName: String {
        switch iconCode {
        // Clear sky
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        
        // Few clouds
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        
        // Scattered clouds
        case "03d", "03n": return "cloud.fill"
        
        // Broken clouds
        case "04d", "04n": return "cloud.fill"
        
        // Shower rain
        case "09d", "09n": return "cloud.rain.fill"
        
        // Rain
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        
        // Thunderstorm
        case "11d", "11n": return "cloud.bolt.rain.fill"
        
        // Snow
        case "13d", "13n": return "cloud.snow.fill"
        
        // Mist
        case "50d", "50n": return "cloud.fog.fill"
        
        default: return "sun.max.fill"
        }
    }
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size))
            .foregroundColor(.yellow)
    }
}

struct WeatherIconView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            WeatherIconView(iconCode: "01d", size: 40)
            WeatherIconView(iconCode: "10d", size: 40)
            WeatherIconView(iconCode: "11d", size: 40)
        }
    }
}
