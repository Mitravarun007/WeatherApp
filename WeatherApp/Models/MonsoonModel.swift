//
//  MonsoonModel.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import Foundation

// Monsoon status enum
enum MonsoonStatus {
    case active         // Heavy rain expected, strong winds
    case approaching    // Monsoon season starting, moderate rain
    case inactive       // Not monsoon season
    
    var emoji: String {
        switch self {
        case .active:
            return "🌧"
        case .approaching:
            return "☁️"
        case .inactive:
            return "☀️"
        }
    }
    
    var description: String {
        switch self {
        case .active:
            return "Monsoon Active"
        case .approaching:
            return "Monsoon Approaching"
        case .inactive:
            return "Clear Season"
        }
    }
    
    var color: String {
        switch self {
        case .active:
            return "#FF4444"      // Red
        case .approaching:
            return "#FFAA00"      // Orange
        case .inactive:
            return "#44AA44"      // Green
        }
    }
}

// Monsoon detector
struct MonsoonDetector {
    let latitude: Double
    let longitude: Double
    
    // Check if location is in South/Southeast Asia monsoon region
    // India: 8°N to 35°N, 68°E to 97°E
    // Southeast Asia: similar region
    var isMonsoonRegion: Bool {
        let isIndianRegion = latitude >= 8 && latitude <= 35 &&
                             longitude >= 68 && longitude <= 97
        
        let isSEAsiaRegion = latitude >= 0 && latitude <= 25 &&
                             longitude >= 90 && longitude <= 140
        
        return isIndianRegion || isSEAsiaRegion
    }
    
    // Detect monsoon status based on rainfall and wind
    func detectStatus(rainProbability: Double, windSpeed: Double, month: Int) -> MonsoonStatus {
        guard isMonsoonRegion else {
            return .inactive
        }
        
        // India monsoon: June to September (months 6-9)
        // SE Asia varies, but generally May-October
        let isMonsoonMonth = month >= 5 && month <= 10
        
        guard isMonsoonMonth else {
            return .inactive
        }
        
        // If heavy rain + strong wind during monsoon months
        if rainProbability > 50 && windSpeed > 5 {
            return .active
        }
        
        // If moderate rain during monsoon months
        if rainProbability > 30 {
            return .approaching
        }
        
        return .inactive
    }
}

// Monsoon info to display
struct MonsoonInfo {
    let status: MonsoonStatus
    let rainIntensity: Double    // 0-100 percentage
    let windSpeed: Double        // in m/s
    let isInMonsoonRegion: Bool
}
