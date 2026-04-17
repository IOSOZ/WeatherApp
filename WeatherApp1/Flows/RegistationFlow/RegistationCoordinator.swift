//
//  RegistationCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 08.03.2026.
//

import Foundation
import UIKit


protocol RegistrationCoordinatorFactory {
    func makeAuthCoordinator()
    func makeMainCoordinator()
}

final class RegistrationCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [Coordinator] = []
    private let factory: RegistrationCoordinatorFactory
    private let moduleFactory = RegistrationModuleFactory()
    
    // MARK: - NavController
    private let navController: UINavigationController
    
    // MARK: - Registration Draft
    private var draft = RegistrationDraft()
    
    // MARK: - Init
    init(navController: UINavigationController,
         factory: RegistrationCoordinatorFactory) {
        self.navController = navController
        self.factory = factory
    }
    
    // MARK: - Start Method
    func start() {
        navController.setNavigationBarHidden(false, animated: false)
        showUsernameStep()
        setupNavigationBarAppearance()
    }
}

// MARK: - Setup Logic
private extension RegistrationCoordinator {
    
    func showUsernameStep() {
        let loginVC = moduleFactory.makeRegisterLoginViewController { [weak self] username in
            guard let self else { return }
            self.draft.username = username
            self.showPasswordStep()
            
        } onBackToAuth: { [weak self] in
            guard let self else { return }
            factory.makeAuthCoordinator()
        }
        navController.setNavigationBarHidden(true, animated: false)
        navController.setViewControllers([loginVC], animated: true)
    }
    
    func showPasswordStep() {
        let passwordVC = moduleFactory.makeRegisterPasswordViewController { [weak self] password in
            guard let self else { return }
            self.draft.password = password
            self.showPinStep()
        } onBackToAuth: { [weak self] in
            guard let self else { return }
            factory.makeAuthCoordinator()
        }
        navController.setNavigationBarHidden(true, animated: false)
        navController.pushViewController(passwordVC, animated: true)

    }
    
    func showPinStep() {
        let pinVC = moduleFactory.makePINCodeViewController { [weak self] pin in
            guard let self else { return }
            self.draft.pin = pin
            self.showFaceIDStep()
        }
        
        navController.pushViewController(pinVC, animated: true)
    }
    
    func showFaceIDStep() {
        let faceIDVC = moduleFactory.makeFaceIDViewController { [weak self] faceIDIsOn in
            guard let self else { return }
            self.draft.isFaceIDEnabled = faceIDIsOn
            self.completeRegistration()
        } onBackToAuth: { [weak self] in
            guard let self else { return }
            factory.makeAuthCoordinator()
        }

        navController.pushViewController(faceIDVC, animated: true)
    }
        
}

private extension RegistrationCoordinator {
    
    // MARK: - Helpers
    func completeRegistration() {
        guard
            let username = draft.username,
            let password = draft.password,
            let pin = draft.pin,
            let biometricIsEnabled = draft.isFaceIDEnabled
        else { return }
        
        AppServices.shared.authService.register(userName: username, password: password) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                AppServices.shared.sessionService.saveSession(userId: user.id)
                AppServices.shared.localSessionStore.savePin(pin)
                AppServices.shared.localSessionStore.setBiometricEnabled(biometricIsEnabled)
                factory.makeMainCoordinator()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Navigation
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

   

