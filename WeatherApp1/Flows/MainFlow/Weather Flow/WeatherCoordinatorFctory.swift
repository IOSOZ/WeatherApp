//
//  WeatherCoordinatorFctory.swift
//  WeatherApp
//
//  Created by Олег Зуев on 12.05.2026.
//

import Foundation
import UIKit

protocol WeatherCoordinatorFactoryProtocol {
    func makeSettingsCoordinator (
        navController: UINavigationController,
        output: SettingsCoordinatorOutput
    ) -> SettingsCoordinator
}

struct WeatherCoordinatorFactory: WeatherCoordinatorFactoryProtocol {
    func makeSettingsCoordinator(
        navController: UINavigationController,
        output: SettingsCoordinatorOutput
    ) -> SettingsCoordinator {
        SettingsCoordinator(
            output: output,
            navController: navController)
    }
}
