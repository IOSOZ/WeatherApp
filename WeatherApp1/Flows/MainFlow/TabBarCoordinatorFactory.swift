//
//  TabBarCoordinatorFactory.swift
//  WeatherApp
//
//  Created by Олег Зуев on 12.05.2026.
//

import Foundation
import UIKit

protocol TabBarCoordinatorFactoryProtocol {
    
    func makeWeatherCoordinator(
        navController: UINavigationController,
        output: WeatherCoordinatorOutput,
        factory: WeatherCoordinatorFactoryProtocol
    ) -> WeatherCoordinator
    
    func makeFavoriteCoordinator(
        navController: UINavigationController,
        output: FavoriteCoordinatorOutput
    ) -> FavoriteCoordinator
    
    
}

struct TabBarCoordinatorFactory: TabBarCoordinatorFactoryProtocol {
    func makeWeatherCoordinator(
        navController: UINavigationController,
        output: WeatherCoordinatorOutput,
        factory: WeatherCoordinatorFactoryProtocol
    ) -> WeatherCoordinator {
        WeatherCoordinator(
            navBar: navController,
            output: output,
            factory: factory
        )
    }
    
    func makeFavoriteCoordinator(
        navController: UINavigationController,
        output: FavoriteCoordinatorOutput
    ) -> FavoriteCoordinator {
        FavoriteCoordinator(
            output: output,
            navBar: navController
        )
    }
}
