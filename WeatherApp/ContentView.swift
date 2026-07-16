//
//  ContentView.swift
//  WeatherApp
//
//  Created by 2602927 on 13/07/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black
                .ignoresSafeArea()
            
            // Weather dashboard
            WeatherDashboardView(
                viewModel: viewModel,
                locationManager: locationManager
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
