//
//  AuthFlowDIContainer.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit


final class AuthModuleFactory {
    func makeLoginViewController(
        onLoginSuccess: @escaping () -> Void,
        onRegister: @escaping () -> Void
    ) -> UIViewController {
        
        let viewModel = LoginViewModel(authService: AppServices.shared.authService)
        viewModel.onLoginSuccess = onLoginSuccess
        viewModel.onRegister = onRegister
        
        let vc = LoginViewController(viewModel: viewModel)
        return vc
    }
    
    func makeLoginPINCodeViewController(
        onMainFlow: @escaping () -> Void,
        onAuthScreen: @escaping () -> Void) -> UIViewController {
            let viewModel = LoginPINViewModel(localSession: AppServices.shared.localSessionStore, biometricService: AppServices.shared.biometricAuthService)
            viewModel.onMainFlow = onMainFlow
            viewModel.onAuthScreen = onAuthScreen
            
            let vc = LoginPINViewController(viewModel: viewModel)
            return vc
        }
}


