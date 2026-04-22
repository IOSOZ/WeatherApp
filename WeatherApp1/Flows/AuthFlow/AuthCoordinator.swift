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
    
    var onFinish: (() -> Void)?
    
    private let factory: AuthCoordinatorFactory
    private let moduleFactory = AuthModuleFactory(
        authService: AppServices.shared.authService,
        localSessionService: AppServices.shared.localSessionStore,
        biometricService: AppServices.shared.biometricAuthService
    )
    
    // MARK: - NavController
    private let navController: UINavigationController
    
    // MARK: - Services
    private let localSessionStore: LocalSessionStoreProtocol
    
    // MARK: - Init
    init(navController: UINavigationController,
         localSessionStore: LocalSessionStoreProtocol = AppServices.shared.localSessionStore,
         factory: AuthCoordinatorFactory) {
        self.navController = navController
        self.localSessionStore = localSessionStore
        self.factory = factory
    }
    
    // MARK: - Start Method
    func start() {
        if localSessionStore.isAuthorized && localSessionStore.hasPin {
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
                self?.factory.makeRegistrationCoordinator()
                self?.onFinish?()
            },
            onRegister: { [weak self] in
                self?.factory.makeRegistrationCoordinator()
                self?.onFinish?()
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



