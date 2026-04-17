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
    private let factory: MainCoordinatorFactory
    private let moduleFactory = MainModuleFactory()
    
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
            guard let self else { return }
            self.factory.makeAuthCoordinator()
        }
        navController.setViewControllers([vc], animated: true)
    }
}
