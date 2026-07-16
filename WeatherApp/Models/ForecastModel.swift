//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import Foundation

// 5-day forecast response from OpenWeatherMap
struct ForecastResponse: Codable {
    let list: [ForecastItem]
    
    struct ForecastItem: Codable {
        let dt: Int // Unix timestamp
        let main: Main
        let weather: [Weather]
        let wind: Wind
        let clouds: Clouds
        let rain: Rain?
        
        struct Main: Codable {
            let temp: Double
            let feelsLike: Double
            let humidity: Int
            
            enum CodingKeys: String, CodingKey {
                case temp
                case feelsLike = "feels_like"
                case humidity
            }
        }
        
        struct Weather: Codable {
            let description: String
            let icon: String
        }
        
        struct Wind: Codable {
            let speed: Double
        }
        
        struct Clouds: Codable {
            let all: Int
        }
        
        struct Rain: Codable {
            let threeH: Double?
            
            enum CodingKeys: String, CodingKey {
                case threeH = "3h"
            }
        }
    }
}

// Simplified forecast day for our app
struct ForecastDay {
    let date: Date
    let tempHigh: Double
    let tempLow: Double
    let description: String
    let icon: String
    let rainProbability: Double
    let humidity: Int
    
    // Format date as "Mon" or "Tue"
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    // Format date as "Jul 15"
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
    }
}
