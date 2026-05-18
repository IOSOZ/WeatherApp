//
//  WatherCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import Foundation
import UIKit

protocol WeatherCoordinatorOutput: AnyObject {
    func requestAuthCoordinator()
}

final class WeatherCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [any Coordinator] = []
    
    var onFinish: (() -> Void)?
    
    private weak var output: WeatherCoordinatorOutput?
    
    private let factory: WeatherCoordinatorFactoryProtocol
    private let moduleFactory = WeatherModuleFactory(
        weatherService: AppServices.shared.weatherService,
        locationService: AppServices.shared.locationService,
        citySearchService: AppServices.shared.citySearchService,
        localSessionStore: AppServices.shared.localSessionStore)
    
    // MARK: - NavBar
    let navBar: UINavigationController
    
    // MARK: - Intin
    init(navBar: UINavigationController, output: WeatherCoordinatorOutput, factory: WeatherCoordinatorFactoryProtocol, ) {
        self.factory = factory
        self.navBar = navBar
        self.output = output
    }
    
    // MARK: - Start Method
    func start() {
        showWeatherScreen()
    }
}

// MARK: - Output Implementation
extension WeatherCoordinator: SettingsCoordinatorOutput {
    func requestAuthFlow() {
        self.output?.requestAuthCoordinator()
    }
}

// MARK: - Create and Start Module
private extension WeatherCoordinator {
    func showWeatherScreen() {
        let vc = moduleFactory.makeWeatherViewController { [weak self] in
            self?.output?.requestAuthCoordinator()
            self?.onFinish?()
        } onSetting: { [weak self] in
            #warning("Тут по идее нельзя винишировать флоу Weather")
            self?.showSettingFlow()
        }
        
        navBar.setViewControllers([vc], animated: false)
    }
}

// MARK: - Create and Start Flow
private extension WeatherCoordinator {
    func showSettingFlow() {        
        let coordinator = factory.makeSettingsCoordinator(navController: navBar, output: self)
        
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.removeChild(coordinator)
        }
        
        addChild(coordinator)
        coordinator.start()
        
    }
}
