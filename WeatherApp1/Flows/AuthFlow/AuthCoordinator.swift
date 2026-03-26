//
//  AuthCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit

enum AuthCoordinatorResult {
    case authorized
    case backToStart
}

final class AuthCoordinator: Coordinator {
    
    // MARK: - Outputs
    var childCoordinators: [Coordinator] = []
    var onFinish: ((AuthCoordinatorResult) -> Void)?
    var onRegistration:(() -> Void)?
    
    // MARK: - DI
    private let navController: UINavigationController
    private let di: AuthFlowDIContainer
    
    // MARK: - Init
    init(navController: UINavigationController, di: AuthFlowDIContainer) {
        self.navController = navController
        self.di = di
    }
    
    // MARK: - Start Method
    func start() {
        if di.services.sessionService.isAuthorized && di.services.localSessionStore.hasPin {
            showPinCodeScreen()
        } else {
            showLoginScreen()
        }
    }
}

// MARK: - Setup Logic
private extension AuthCoordinator {
    
    func showLoginScreen() {
        let vc = di.makeLoginViewController(
            onLoginSuccess: { [weak self] in
                self?.onFinish?(.authorized)
            },
            onRegister: { [weak self] in
                self?.onRegistration?()
            })
        
        navController.setViewControllers([vc], animated: true)
    }
    
    func showPinCodeScreen() {
        let vc = di.makeLoginPINCodeViewController(
            onMainFlow: { [weak self] in
                self?.onFinish?(.authorized)
                
            }, onAuthScreen: {
                self.showLoginScreen()
            })
        
        navController.setViewControllers([vc], animated: true)
    }
    
}



