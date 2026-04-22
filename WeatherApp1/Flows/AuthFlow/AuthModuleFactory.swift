//
//  AuthFlowDIContainer.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit


final class AuthModuleFactory {

    var authService: AuthServiceProtocol
    var localSessionService: LocalSessionStoreProtocol
    var biometricService: BiomerticAuthServiceProtocol
    
    init(authService: AuthServiceProtocol,
         localSessionService: LocalSessionStoreProtocol,
         biometricService: BiomerticAuthServiceProtocol)
    {
        self.authService = authService
        self.localSessionService = localSessionService
        self.biometricService = biometricService
    }
    
    func makeLoginViewController(
        onLoginSuccess: @escaping () -> Void,
        onRegister: @escaping () -> Void
    ) -> UIViewController {
        
        let viewModel = LoginViewModel(authService: authService)
        viewModel.onLoginSuccess = onLoginSuccess
        viewModel.onRegister = onRegister
        
        let vc = LoginViewController(viewModel: viewModel)
        return vc
    }
    
    func makeLoginPINCodeViewController(
        onMainFlow: @escaping () -> Void,
        onAuthScreen: @escaping () -> Void) -> UIViewController {
            let viewModel = LoginPINViewModel(localSession: localSessionService, biometricService: biometricService)
            viewModel.onMainFlow = onMainFlow
            viewModel.onAuthScreen = onAuthScreen
            
            let vc = LoginPINViewController(viewModel: viewModel)
            return vc
        }
}


