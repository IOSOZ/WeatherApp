//
//  MainCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation
import UIKit

protocol MainCoordinatorFactory {
    func makeAuthCoordinator()
}


final class MainCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [Coordinator] = []
    
    var onFinish: (() -> Void)?
    
    private let factory: MainCoordinatorFactory
    
    private let moduleFactory = MainModuleFactory(
        weatherService: AppServices.shared.weatherService,
        locationService: AppServices.shared.locationService,
        citySearchService: AppServices.shared.citySearchService,
        localSessionStore: AppServices.shared.localSessionStore
    )
    
    // MARK: - NavController
    private let navController: UINavigationController
    
    // MARK: - Init
    init(navController: UINavigationController, factory: MainCoordinatorFactory) {
        self.factory = factory
        self.navController = navController
    }
    
    // MARK: - Start Method
    func start() {
        navController.setNavigationBarHidden(true, animated: false)
        showWeatherScreen()
    }
}

// MARK: - Setup Logic
private extension MainCoordinator {
    func showWeatherScreen() {
        let vc = moduleFactory.makeWeatherViewController { [weak self] in
            self?.factory.makeAuthCoordinator()
            self?.onFinish?()
        }
        navController.setViewControllers([vc], animated: true)
    }
}
