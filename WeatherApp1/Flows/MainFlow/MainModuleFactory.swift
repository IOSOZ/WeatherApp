//
//  MainFlowDIContainer.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation
import UIKit


final class MainModuleFactory {
    var weatherService: WeatherServiceProtocol
    var locationService: LocationServiceProtocol
    var citySearchService: CitySearchServiceProtocol
    var localSessionStore: LocalSessionStoreProtocol
    
    init(weatherService: WeatherServiceProtocol,
         locationService: LocationServiceProtocol,
         citySearchService: CitySearchServiceProtocol,
         localSessionStore: LocalSessionStoreProtocol)
    {
        self.weatherService = weatherService
        self.locationService = locationService
        self.citySearchService = citySearchService
        self.localSessionStore = localSessionStore
    }
    
    func makeWeatherViewController(
        onBackToAuth: @escaping () -> Void
    )  -> UIViewController {
        let viewModel = WeatherViewModel(
            weatherService: weatherService,
            locationService: locationService,
            citySearchService: citySearchService,
            localSessionStore: localSessionStore
        )
        viewModel.onBackToAuth = onBackToAuth
        
        let viewController = WeatherViewController(viewModel: viewModel)
        return viewController
    }
}
