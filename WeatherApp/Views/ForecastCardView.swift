//
//  ForecastCardView.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import SwiftUI

struct ForecastCardView: View {
    let forecastDay: ForecastDay
    
    var body: some View {
        VStack(spacing: 8) {
            // Day name
            Text(forecastDay.dayName)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            // Date
            Text(forecastDay.dateString)
                .font(.caption2)
                .foregroundColor(.gray)
            
            // Weather icon
            WeatherIconView(iconCode: forecastDay.icon, size: 32)
                .padding(.vertical, 4)
            
            // Temperature
            Text(String(format: "%.0f°C", forecastDay.tempHigh))
                .font(.headline)
            
            // Rain probability
            HStack(spacing: 4) {
                Image(systemName: "cloud.rain.fill")
                    .font(.caption2)
                    .foregroundColor(.blue)
                
                Text(String(format: "%.0f%%", forecastDay.rainProbability))
                    .font(.caption2)
            }
            .foregroundColor(.blue)
        }
        .frame(width: 100)
        .padding(12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

struct ForecastCardView_Previews: PreviewProvider {
    static var previews: some View {
        let testForecast = ForecastDay(
            date: Date(),
            tempHigh: 28,
            tempLow: 22,
            description: "Rainy",
            icon: "10d",
            rainProbability: 75,
            humidity: 85
        )
        
        ForecastCardView(forecastDay: testForecast)
            .preferredColorScheme(.dark)
    }
}
