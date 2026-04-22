//
//  RegistationCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 08.03.2026.
//

import Foundation
import UIKit

enum RegistrationError: Error {
    case missingUsername
    case missingPassword
    case missingPin
    case missingFaceIDChoice
    case networkTimeout
    case invalidResponse
}

protocol RegistrationCoordinatorFactory {
    func makeAuthCoordinator()
    func makeMainCoordinator()
}

final class RegistrationCoordinator: Coordinator {
    
    // MARK: - DI
    private let localSessionStore: LocalSessionStoreProtocol
    private let authService: AuthServiceProtocol
    
    // MARK: - Flow Work
    var childCoordinators: [Coordinator] = []
    
    var onFinish: (() -> Void)?
    
    private let factory: RegistrationCoordinatorFactory
    private let moduleFactory = RegistrationModuleFactory(
        authService: AppServices.shared.authService,
        biomerticAuthService: AppServices.shared.biometricAuthService,
        sessionService: AppServices.shared.localSessionStore
    )
    
    // MARK: - NavController
    private let navController: UINavigationController
    
    // MARK: - Registration Draft
    private var draft = RegistrationDraft()
    
    // MARK: - Init
    init(navController: UINavigationController,
         factory: RegistrationCoordinatorFactory,
         localSessionStore: LocalSessionStoreProtocol,
         authService: AuthServiceProtocol) {
        self.navController = navController
        self.factory = factory
        self.localSessionStore = localSessionStore
        self.authService = authService
    }
    
    // MARK: - Start Method
    func start() {
        navController.setNavigationBarHidden(false, animated: false)
        setupNavigationBarAppearance()
        if localSessionStore.isAuthorized {
            showPinStep()
        } else {
            showUsernameStep()
        }
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
            self?.factory.makeAuthCoordinator()
            self?.onFinish?()
        }
        navController.setViewControllers([loginVC], animated: true)
    }
    
    func showPasswordStep() {
        let passwordVC = moduleFactory.makeRegisterPasswordViewController { [weak self] password in
            guard let self else { return }
            self.draft.password = password
            self.showPinStep()
        } onBackToAuth: { [weak self] in
            self?.factory.makeAuthCoordinator()
            self?.onFinish?()
        }
        navController.pushViewController(passwordVC, animated: true)

    }
    
    func showPinStep() {
        let pinVC = moduleFactory.makePINCodeViewController { [weak self] pin in
            guard let self else { return }
            self.draft.pin = pin
            self.showFaceIDStep()
        }
        navController.setNavigationBarHidden(true, animated: true)
        navController.pushViewController(pinVC, animated: true)
    }
    
    func showFaceIDStep() {
        let faceIDVC = moduleFactory.makeFaceIDViewController { [weak self] faceIDIsOn in
            guard let self else { return }
            self.draft.isFaceIDEnabled = faceIDIsOn
            
            do {
                if localSessionStore.isAuthorized {
                    try completePinSetup()
                } else {
                    try completeRegistration()
                }
            } catch {
                print("Error ", error)
            }
            
        } onBackToAuth: { [weak self] in
            self?.factory.makeAuthCoordinator()
            self?.onFinish?()
        }

        navController.pushViewController(faceIDVC, animated: true)
    }
        
}

private extension RegistrationCoordinator {
    
    // MARK: - Helpers
    func completeRegistration() throws {
        guard let username = draft.username else {
            throw RegistrationError.missingUsername
        }
        guard let password = draft.password else {
            throw RegistrationError.missingPassword
        }
        guard let pin = draft.pin else {
            throw RegistrationError.missingPin
        }
        guard let biometricIsEnabled = draft.isFaceIDEnabled else {
            throw RegistrationError.missingFaceIDChoice
        }
        
        authService.register(userName: username, password: password) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                localSessionStore.saveSession(userId: user.id)
                localSessionStore.savePin(pin)
                localSessionStore.setBiometricEnabled(biometricIsEnabled)
                onFinish?()
                factory.makeMainCoordinator()
            case .failure(let error):
                print("Registration error:", error)
            }
        }
    }
    
    func completePinSetup() throws {
        guard let pin = draft.pin else {
            throw RegistrationError.missingPin
        }
        
        guard let biometricIsEnabled = draft.isFaceIDEnabled else {
            throw RegistrationError.missingFaceIDChoice
        }
        
        localSessionStore.savePin(pin)
        localSessionStore.setBiometricEnabled(biometricIsEnabled)
        onFinish?()
        factory.makeMainCoordinator()
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
            .foregroundColor: UIColor.appBlue
         ]
         
         appearance.backButtonAppearance = backItemAppearance
         
         navController.navigationBar.standardAppearance = appearance
         navController.navigationBar.scrollEdgeAppearance = appearance
         navController.navigationBar.compactAppearance = appearance
         navController.navigationBar.tintColor = .black
    }
}

   

