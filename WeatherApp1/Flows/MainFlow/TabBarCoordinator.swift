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

protocol WeatherCoordinatorFactory {
    func makeAuthCoordinator()
    func makeSettingsCoordinator()
    func makeFavoriteCoordinator()
}

protocol FavoriteCoordinatorFactory {
    
}


final class TabBarCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    
    private let factory: MainCoordinatorFactory
    
    // MARK: - NavController
    private let tabBarController: UITabBarController
    
    // MARK: - Init
    init(tabBarController: UITabBarController, factory: MainCoordinatorFactory) {
        self.factory = factory
        self.tabBarController = tabBarController
    }
    
    // MARK: - Start Method
    func start() {
        makeWeatherCoordinator()
    }
}

extension TabBarCoordinator: SettingsCoordinatorFactory, WeatherCoordinatorFactory,FavoriteCoordinatorFactory {
    func makeAuthCoordinator() {
        onFinish?()
        factory.makeAuthCoordinator()
    }
    
    func makeSettingsCoordinator() {
        // TODO
    }
    
    func makeWeatherCoordinator() {
        let coordinator = WeatherCoordinator(factory: self, tabBar: tabBarController)
        
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return}
            self.removeChild(coordinator)
        }
        addChild(coordinator)
        coordinator.start()
        
    }
    
    func makeFavoriteCoordinator() {
        // TODO
    }
    
}
