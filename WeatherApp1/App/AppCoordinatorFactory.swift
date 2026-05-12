//
//  CoordinatorFactory.swift
//  WeatherApp
//
//  Created by Олег Зуев on 06.04.2026.
//

import Foundation
import UIKit

protocol AppCoordinatorFactoryProtocol {
    
    func makeAuthCoordinator(
        navController: UINavigationController,
        output: AuthCoordinatorOutput
    ) -> AuthCoordinator
    
    func makeRegistrationCoordinator(
        navController: UINavigationController,
        output: RegistrationCoordinatorOutput
    ) -> RegistrationCoordinator
    
    func makeTabBarCoordinator(
        tabBarController: UITabBarController,
        output: TabBarCoordinatorOutput,
        factory: TabBarCoordinatorFactoryProtocol
    ) -> TabBarCoordinator
}


struct AppCoordinatorFactory: AppCoordinatorFactoryProtocol {
    
    func makeAuthCoordinator(
        navController: UINavigationController,
        output: AuthCoordinatorOutput
    ) -> AuthCoordinator {
        return AuthCoordinator(
            navController: navController,
            output: output
        )
    }
    
    func makeRegistrationCoordinator(
        navController: UINavigationController,
        output: RegistrationCoordinatorOutput
    ) -> RegistrationCoordinator {
        RegistrationCoordinator(
            navController: navController,
            output: output,
            localSessionStore: AppServices.shared.localSessionStore,
            authService: AppServices.shared.authService
        )
    }
    
    func makeTabBarCoordinator(
        tabBarController: UITabBarController,
        output: TabBarCoordinatorOutput,
        factory: TabBarCoordinatorFactoryProtocol
    ) -> TabBarCoordinator {
        TabBarCoordinator(
            tabBarController: tabBarController,
            output: output,
            factory: factory
        )
    }
}
