//
//  WeatherDashboardView.swift
//  WeatherApp
//
//  Created by 2602927 on 15/07/26.
//

import SwiftUI

struct WeatherDashboardView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.3),
                    Color.cyan.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 20) {
                // Location denied message
                if locationManager.locationDenied {
                    VStack(spacing: 12) {
                        Image(systemName: "location.slash.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        
                        Text("Location Access Denied")
                            .font(.headline)
                        
                        Text("Please enable location in Settings → WeatherApp → Location")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Loading spinner
                else if viewModel.isLoading {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Loading weather...")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                // Error message
                else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        
                        Text("Error")
                            .font(.headline)
                        
                        Text(errorMessage)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Weather content (when data is loaded)
                else if let weather = viewModel.currentWeather {
                    ScrollView {
                        VStack(alignment: .center, spacing: 20) {
                            // City name
                            VStack(spacing: 4) {
                                Text(weather.cityName)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(weather.country)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            // Large weather icon
                            WeatherIconView(iconCode: weather.icon, size: 80)
                                .padding(.vertical, 10)
                            
                            // Temperature
                            VStack(spacing: 4) {
                                Text(String(format: "%.0f°C", weather.temperature))
                                    .font(.system(size: 56))
                                    .fontWeight(.bold)
                                
                                Text(weather.description.capitalized)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            
                            // Feels like
                            Text("Feels like \(String(format: "%.0f°C", weather.feelsLike))")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            // Weather details in grid
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    // Humidity
                                    DetailCard(
                                        icon: "humidity.fill",
                                        label: "Humidity",
                                        value: "\(weather.humidity)%"
                                    )
                                    
                                    // Wind
                                    DetailCard(
                                        icon: "wind",
                                        label: "Wind",
                                        value: String(format: "%.1f m/s", weather.windSpeed)
                                    )
                                }
                                
                                HStack(spacing: 12) {
                                    // Clouds
                                    DetailCard(
                                        icon: "cloud.fill",
                                        label: "Clouds",
                                        value: "\(weather.cloudPercentage)%"
                                    )
                                    
                                    // Rain
                                    DetailCard(
                                        icon: "cloud.rain.fill",
                                        label: "Rain",
                                        value: String(format: "%.1f mm", weather.rainProbability)
                                    )
                                }
                            }
                            
                            // Monsoon info card (if in monsoon region)
                            if let monsoonInfo = viewModel.monsoonInfo,
                               monsoonInfo.isInMonsoonRegion {
                                MonsoonInfoCard(monsoonInfo: monsoonInfo)
                            }
                            
                            // 5-day forecast
                            VStack(alignment: .leading, spacing: 12) {
                                Text("5-Day Forecast")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(viewModel.forecastDays.indices, id: \.self) { index in
                                            ForecastCardView(forecastDay: viewModel.forecastDays[index])
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Last updated
                            Text(viewModel.lastUpdatedText)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        .padding(.vertical, 20)
                    }
                    .refreshable {
                        // Pull-to-refresh support
                        if let lat = locationManager.latitude,
                           let lon = locationManager.longitude {
                            viewModel.loadWeather(latitude: lat, longitude: lon)
                            
                            // Wait a bit for data to load
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                        }
                    }
                }
            }
        }
        
        // When location updates, fetch weather
        .onChange(of: locationManager.isLocationReady) { isReady in
            if isReady,
               let latitude = locationManager.latitude,
               let longitude = locationManager.longitude {
                viewModel.loadWeather(latitude: latitude, longitude: longitude)
            }
        }
    }
}

// Helper component for weather detail cards
struct DetailCard: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct WeatherDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = LocationManager()
        let viewModel = WeatherViewModel()
        
        WeatherDashboardView(viewModel: viewModel, locationManager: locationManager)
            .preferredColorScheme(.dark)
    }
}
