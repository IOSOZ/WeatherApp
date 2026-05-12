//
//  AuthCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit

protocol AuthCoordinatorOutput: AnyObject {
    func requestRegistrationFlow()
    func requestTabBarFlow()
}

final class AuthCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [Coordinator] = []
    
    var onFinish: (() -> Void)?
    
    private weak var output: AuthCoordinatorOutput?
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
         output: AuthCoordinatorOutput) {
        self.navController = navController
        self.localSessionStore = localSessionStore
        self.output = output
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
                self?.output?.requestRegistrationFlow()
                self?.onFinish?()
            },
            onRegister: { [weak self] in
                self?.output?.requestRegistrationFlow()
                self?.onFinish?()
            }
        )
        navController.setViewControllers([vc], animated: true)
    }
    
    func showPinCodeScreen() {
        let vc = moduleFactory.makeLoginPINCodeViewController(
            onMainFlow: { [weak self] in
                self?.output?.requestTabBarFlow()
                
            }, onAuthScreen: { [weak self] in
                self?.showLoginScreen()
            }
        )
        
        navController.setViewControllers([vc], animated: true)
    }
    
}



