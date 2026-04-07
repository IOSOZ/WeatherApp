//
//  AuthCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit

protocol AuthCoordinatorFactory {
    func makeRegistrationCoordinator()
    func makeMainCoordinator()
}

final class AuthCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [Coordinator] = []
    private let factory: AuthCoordinatorFactory
    private let moduleFactory = AuthModuleFactory()
    
    // MARK: - NavController
    private let navController: UINavigationController
    
    // MARK: - Services
    private let sessionService: SessionServiceProtocol
    private let localSessionStore: LocalSessionStoreProtocol
    
    // MARK: - Init
    init(navController: UINavigationController,
         sessionService: SessionServiceProtocol = AppServices.shared.sessionService,
         localSessionStore: LocalSessionStoreProtocol = AppServices.shared.localSessionStore,
         factory: AuthCoordinatorFactory) {
        self.navController = navController
        self.sessionService = sessionService
        self.localSessionStore = localSessionStore
        self.factory = factory
    }
    
    // MARK: - Start Method
    func start() {
        if sessionService.isAuthorized && localSessionStore.hasPin {
            showPinCodeScreen()
        } else {
            showLoginScreen()
        }
    }
}

// MARK: - Setup Logic
private extension AuthCoordinator {
    func showLoginScreen() {
        let vc = moduleFactory.makeLoginViewController(
            onLoginSuccess: { [weak self] in
                self?.factory.makeMainCoordinator()
            },
            onRegister: { [weak self] in
                self?.factory.makeRegistrationCoordinator()
            }
        )
        navController.setViewControllers([vc], animated: true)
    }
    
    func showPinCodeScreen() {
        let vc = moduleFactory.makeLoginPINCodeViewController(
            onMainFlow: { [weak self] in
                self?.factory.makeMainCoordinator()
                
            }, onAuthScreen: { [weak self] in
                self?.showLoginScreen()
            })
        
        navController.setViewControllers([vc], animated: true)
    }
    
}



