//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    // Published properties automatically update all SwiftUI views that use them
    @Published var currentWeather: CurrentWeather?
    @Published var forecastDays: [ForecastDay] = []
    @Published var monsoonInfo: MonsoonInfo?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?
    
    // Store location for reference
    private var currentLatitude: Double?
    private var currentLongitude: Double?
    
    // Service instances
    private let weatherService = WeatherService.shared
    
    // Load weather data for a given location
    func loadWeather(latitude: Double, longitude: Double) {
        // Don't reload if location hasn't changed much (within 100 meters)
        if let prevLat = currentLatitude, let prevLon = currentLongitude {
            let distance = calculateDistance(lat1: prevLat, lon1: prevLon,
                                            lat2: latitude, lon2: longitude)
            if distance < 0.1 { // Less than ~100 meters
                print("📍 Location unchanged, skipping reload")
                return
            }
        }
        
        currentLatitude = latitude
        currentLongitude = longitude
        
        // Clear previous errors and set loading state
        errorMessage = nil
        isLoading = true
        
        // Fetch data asynchronously
        Task {
            do {
                // Fetch current weather
                let weather = try await weatherService.fetchCurrentWeather(
                    latitude: latitude,
                    longitude: longitude
                )
                
                // Fetch forecast
                let forecast = try await weatherService.fetchForecast(
                    latitude: latitude,
                    longitude: longitude
                )
                
                // Detect monsoon status
                let monsoon = detectMonsoon(
                    weather: weather,
                    latitude: latitude,
                    longitude: longitude
                )
                
                // Update UI on main thread
                DispatchQueue.main.async {
                    self.currentWeather = weather
                    self.forecastDays = forecast
                    self.monsoonInfo = monsoon
                    self.lastUpdated = Date()
                    self.isLoading = false
                }
                
                print("✅ All weather data loaded successfully")
                
            } catch {
                // Handle errors
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load weather: \(error.localizedDescription)"
                    self.isLoading = false
                    print("❌ Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Detect monsoon status based on location and weather
    private func detectMonsoon(weather: CurrentWeather, latitude: Double, longitude: Double) -> MonsoonInfo {
        let detector = MonsoonDetector(latitude: latitude, longitude: longitude)
        
        // Get current month (1-12)
        let month = Calendar.current.component(.month, from: Date())
        
        // Determine monsoon status
        let status = detector.detectStatus(
            rainProbability: weather.rainProbability,
            windSpeed: weather.windSpeed,
            month: month
        )
        
        return MonsoonInfo(
            status: status,
            rainIntensity: weather.rainProbability,
            windSpeed: weather.windSpeed,
            isInMonsoonRegion: detector.isMonsoonRegion
        )
    }
    
    // Calculate distance between two coordinates (simplified, in degrees)
    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let latDiff = abs(lat1 - lat2)
        let lonDiff = abs(lon1 - lon2)
        return sqrt(latDiff * latDiff + lonDiff * lonDiff)
    }
    
    // Format last updated time as string
    var lastUpdatedText: String {
        guard let lastUpdated = lastUpdated else { return "Never" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "Updated \(formatter.string(from: lastUpdated))"
    }
}
