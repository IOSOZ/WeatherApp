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
    
    func start() {
        <#code#>
    }
    
    
}
