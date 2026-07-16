//
//  MonsoonInfoCard.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import SwiftUI

struct MonsoonInfoCard: View {
    let monsoonInfo: MonsoonInfo
    
    // Convert hex color string to SwiftUI Color
    var statusColor: Color {
        switch monsoonInfo.status {
        case .active:
            return Color(red: 1.0, green: 0.27, blue: 0.27)  // Red
        case .approaching:
            return Color(red: 1.0, green: 0.67, blue: 0)     // Orange
        case .inactive:
            return Color(red: 0.27, green: 0.67, blue: 0.27) // Green
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(monsoonInfo.status.emoji)
                    .font(.system(size: 24))
                
                Text(monsoonInfo.status.description)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Rain Intensity
            HStack {
                Label("Rain Chance", systemImage: "cloud.rain.fill")
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(String(format: "%.0f%%", monsoonInfo.rainIntensity))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            // Wind Speed
            HStack {
                Label("Wind Speed", systemImage: "wind")
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(String(format: "%.1f m/s", monsoonInfo.windSpeed))
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(statusColor.opacity(0.8))
        .cornerRadius(12)
        .padding()
    }
}

struct MonsoonInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        let testMonsoon = MonsoonInfo(
            status: .active,
            rainIntensity: 75,
            windSpeed: 8.5,
            isInMonsoonRegion: true
        )
        
        MonsoonInfoCard(monsoonInfo: testMonsoon)
            .preferredColorScheme(.dark)
    }
}
