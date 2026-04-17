//
//  MainFlowDIContainer.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation
import UIKit


final class MainModuleFactory {
    func makeWeatherViewController(
        onBackToAuth: @escaping () -> Void
    )  -> UIViewController {
        let viewModel = WeatherViewModel(
            weatherService: AppServices.shared.weatherService,
//            weatherService: MockWeatherService(),
            locationService: AppServices.shared.locationService,
            citySearchService: AppServices.shared.citySearchService
        )
        viewModel.onBackToAuth = onBackToAuth
        
        let viewController = WeatherViewController(viewModel: viewModel)
        return viewController
    }
}
