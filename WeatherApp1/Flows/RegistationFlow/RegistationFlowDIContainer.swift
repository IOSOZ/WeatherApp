//
//  RegistationFlowDIContainer.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.03.2026.
//

import Foundation
import UIKit

final class RegistrationFlowDIContainer {
    
    // MARK: - Services
    let services: AppServices
    
    // MARK: - Init
    init(services: AppServices) {
        self.services = services
    }
}

// MARK: - Creation MVP Module
extension RegistrationFlowDIContainer {
    func makeRegisterLoginViewController(
        onLoginEntered: @escaping (String) -> Void,
        onBackToAuth: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = RegisterUsernameViewModel(authService: services.authService)
        viewModel.onNextStep = onLoginEntered
        viewModel.onBackToAuth = onBackToAuth
        
        let viewController = RegisterLoginViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeRegisterPasswordViewController(
        onPasswordEntered: @escaping (String) -> Void,
        onBackToAuth: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = RegisterPasswordViewModel()
        viewModel.onNextStep = onPasswordEntered
        viewModel.onBackToAuth = onBackToAuth
        
        let viewController = RegisterPasswordViewController(viewModel: viewModel)
        return viewController
    }
    
    func makePINCodeViewController(
        onNextStep: @escaping (String) -> Void
    ) -> UIViewController {
        let viewModel = PinCodeViewModel()
        viewModel.onNextStep = onNextStep
        
        let viewController = PinCodeViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func makeFaceIDViewController(
        onNextStep: @escaping (Bool) -> Void,
        onBackToAuth: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = FaceIDViewModel(biomerticAuthService: services.biometricAuthService)
        viewModel.onNextStep = onNextStep
        viewModel.onBackToAuth = onBackToAuth
        
        let viewController = FaceIDViewController(viewModel: viewModel)
        
        return viewController
    }

}
