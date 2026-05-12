//
//  GreenScreenCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import Foundation
import UIKit

protocol SettingsCoordinatorOutput: AnyObject {
    func requestAuthFlow()
}

final class SettingsCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [any Coordinator] = []
    
    var onFinish: (() -> Void)?
    
    private weak var output: SettingsCoordinatorOutput?
    private let moduleFactory = SettingsModuleFactory()
    
    // MARK: - NavController
    let navController: UINavigationController
    
    init (output: SettingsCoordinatorOutput, navController: UINavigationController) {
        self.output = output
        self.navController = navController
    }
    
    func start() {
        showSettingsScreen()
    }
}

private extension SettingsCoordinator {
    func showSettingsScreen() {
        let settingsVC = moduleFactory.makeSettingsViewController { [weak self] in
            self?.navController.popViewController(animated: true)
            self?.onFinish?()
        } onAuthFlow: { [weak self] in
            self?.output?.requestAuthFlow()
            self?.onFinish?()
        }
        
        settingsVC.hidesBottomBarWhenPushed = true 
        navController.pushViewController(settingsVC, animated: true)
    }
}
