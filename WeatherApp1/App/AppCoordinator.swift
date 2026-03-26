//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Outputs
    private let window: UIWindow
    private let navController: UINavigationController
    private let di: AppDIContainer
    
    // MARK: - Init
    init( window: UIWindow, di: AppDIContainer) {
        self.window = window
        self.navController = UINavigationController()
        self.di = di
    }
    
    // MARK: - Start Method
    func start() {
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
#warning("Тут сбрасываю юзердефолтс")
        //        di.services.authService.logout()
        //        di.services.localSessionStore.clearAll()
        showAuthFlow()
        
    }
}
    
// MARK: - Creation Flows
private extension AppCoordinator {
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navController: navController, di: AuthFlowDIContainer(services: di.services))
        authCoordinator.onFinish = { [weak self, weak authCoordinator] result in
            guard let self else { return }
            if let authCoordinator { self.removeChild(authCoordinator) }
            
            switch result {
            case .authorized:
                self.showMainFlow()
            case .backToStart:
                authCoordinator?.start()
            }
            
        }
        authCoordinator.onRegistration = { [weak self, weak authCoordinator] in
            guard let self else { return }
            if let authCoordinator { self.removeChild(authCoordinator) }
            self.showRegisterFlow()
        }
        addChild(authCoordinator)
        authCoordinator.start()
    }
    
    func showRegisterFlow() {
        let registerCoordinator = RegistrationCoordinator(navController: navController, di: RegistrationFlowDIContainer(services: di.services))
        registerCoordinator.onFinish = { [weak self, weak registerCoordinator] in
            guard let self else { return }
            if let registerCoordinator { self.removeChild(registerCoordinator)}
            self.showAuthFlow()
        }
        registerCoordinator.onAuth = { [weak self, weak registerCoordinator] in
            guard let self else { return }
            if let registerCoordinator { self.removeChild(registerCoordinator)}
            self.showAuthFlow()
        }
        
        addChild(registerCoordinator)
        registerCoordinator.start()
    }
    
    func showMainFlow() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        vc.title = "Main"
        
        navController.setViewControllers([vc], animated: false)
    }
}
