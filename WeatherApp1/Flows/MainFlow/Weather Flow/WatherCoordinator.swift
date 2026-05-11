//
//  WatherCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import Foundation
import UIKit


final class WeatherCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [any Coordinator] = []
    
    var onFinish: (() -> Void)?
    private let factory: WeatherCoordinatorFactory
    private let moduleFactory = WeatherModuleFactory(
        weatherService: AppServices.shared.weatherService,
        locationService: AppServices.shared.locationService,
        citySearchService: AppServices.shared.citySearchService,
        localSessionStore: AppServices.shared.localSessionStore)
    
    // MARK: - NavController
    let tabBar: UITabBarController
    
    init(factory: WeatherCoordinatorFactory, tabBar: UITabBarController) {
        self.factory = factory
        self.tabBar = tabBar
    }
    
    // MARK: - Start Method
    func start() {
        showWeatherScreen()
    }
}

// MARK: - Setup Logic
private extension WeatherCoordinator {
    func showWeatherScreen() {
        let vc = moduleFactory.makeWeatherViewController {[weak self] in
            self?.factory.makeAuthCoordinator()
        }
        
        tabBar.setViewControllers([vc], animated: false)
    }
}
