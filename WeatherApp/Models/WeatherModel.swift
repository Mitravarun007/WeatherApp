//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import Foundation

// Current weather data structure
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let sys: Sys
    let name: String
    
    struct Coord: Codable {
        let lat: Double
        let lon: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
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
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int?
    }
    
    struct Clouds: Codable {
        let all: Int // cloud percentage
    }
    
    struct Rain: Codable {
        let oneH: Double? // rain in last hour
        
        enum CodingKeys: String, CodingKey {
            case oneH = "1h"
        }
    }
    
    struct Sys: Codable {
        let country: String
    }
}

// Simplified weather model for our app
struct CurrentWeather {
    let cityName: String
    let country: String
    let temperature: Double
    let feelsLike: Double
    let description: String
    let icon: String
    let humidity: Int
    let windSpeed: Double
    let cloudPercentage: Int
    let rainProbability: Double
    
    init(from response: WeatherResponse) {
        self.cityName = response.name
        self.country = response.sys.country
        self.temperature = response.main.temp
        self.feelsLike = response.main.feelsLike
        self.description = response.weather.first?.description ?? "Unknown"
        self.icon = response.weather.first?.icon ?? "01d"
        self.humidity = response.main.humidity
        self.windSpeed = response.wind.speed
        self.cloudPercentage = response.clouds.all
        self.rainProbability = response.rain?.oneH ?? 0.0
    }
}
