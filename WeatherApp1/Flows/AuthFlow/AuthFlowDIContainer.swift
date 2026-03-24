//
//  AuthFlowDIContainer.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit

final class AuthFlowDIContainer {
    
    // MARK: - Services
    let services: AppServices
    
    // MARK: - Init
    init(services: AppServices) {
        self.services = services
    }
}

extension AuthFlowDIContainer {
    func makeLoginViewController(
        onLoginSuccess: @escaping () -> Void,
        onRegister: @escaping () -> Void
    ) -> UIViewController {
        
        let viewModel = LoginViewModel(authService: services.authService)
        viewModel.onLoginSuccess = onLoginSuccess
        viewModel.onRegister = onRegister
        
        let vc = LoginViewController2(viewModel: viewModel)
        
        return vc
    }
    
    func makeLoginPINCodeViewController(
        onMainFlow: @escaping () -> Void,
        onAuthScreen: @escaping () -> Void) -> UIViewController {
            let viewModel = LoginPINViewModel(localSession: services.localSessionStore, biometricService: services.biometricAuthService)
            viewModel.onMainFlow = onMainFlow
            viewModel.onAuthScreen = onAuthScreen
            
            let vc = LoginPINViewController(viewModel: viewModel)
            return vc
        }
        
}


