//
//  RegistationCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 08.03.2026.
//

import Foundation
import UIKit


final class RegistrationCoordinator: Coordinator {
    
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var onAuth: (() -> Void)?
    
    private let di: RegistrationFlowDIContainer
    private let navController: UINavigationController
    
    private var draft = RegistrationDraft()
    
    init(navController: UINavigationController, di: RegistrationFlowDIContainer) {
        self.navController = navController
        self.di = di
    }
    
    
    func start() {
        navController.setNavigationBarHidden(false, animated: false)
        showUsernameStep()
        setupNavigationBarAppearance()
    }
}

private extension RegistrationCoordinator {
    
    func showUsernameStep() {
        let loginVC = di.makeRegisterLoginViewController { [weak self] username in
            guard let self else { return }
            self.draft.username = username
            self.showPasswordStep()
            
        } onBackToAuth: { [weak self] in
            guard let self else { return }
            self.onAuth?()
        }
        navController.setNavigationBarHidden(true, animated: false)
        navController.setViewControllers([loginVC], animated: true)
    }
    
    func showPasswordStep() {
        let passwordVC = di.makeRegisterPasswordViewController { [weak self] password in
            guard let self else { return }
            self.draft.password = password
            self.showPinStep()
        } onBackToAuth: { [weak self] in
            guard let self else { return }
            self.onAuth?()
        }
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(passwordVC, animated: true)

    }
    
    func showPinStep() {
        let pinVC = di.makePINCodeViewController { [weak self] pin in
            guard let self else { return }
            self.draft.pin = pin
            self.showFaceIDStep()
        }
        
        navController.pushViewController(pinVC, animated: true)
    }
    
    func showFaceIDStep() {
        let faceIDVC = di.makeFaceIDViewController { [weak self] faceIDIsOn in
            guard let self else { return }
            self.draft.isFaceIDEnabled = faceIDIsOn
            self.completeRegistration()
        } onBackToAuth: { [weak self] in
            guard let self else { return }
            self.onAuth?()
        }

        navController.pushViewController(faceIDVC, animated: true)
    }
        
}

private extension RegistrationCoordinator {
    
    func completeRegistration() {
        guard
            let username = draft.username,
            let password = draft.password,
            let pin = draft.pin,
            let biometricIsEnabled = draft.isFaceIDEnabled
        else { return }
        
        di.services.authService.register(userName: username, password: password) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                self.di.services.sessionService.saveSession(userId: user.id)
                self.di.services.localSessionStore.savePin(pin)
                self.di.services.localSessionStore.setBiometricEnabled(biometricIsEnabled)
                self.onFinish?()
            case .failure(let error):
                print("Registration failed")
            }
        }
    }
    
     func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = .white
        
        appearance.shadowColor = UIColor.separator

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]

        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]

        appearance.backButtonAppearance = backItemAppearance

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        navController.navigationBar.compactAppearance = appearance
        navController.navigationBar.tintColor = .black
    }
}

   
