//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {

    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Outputs
    private let window: UIWindow
    private let navController: UINavigationController
    
    // MARK: - Init
    init( window: UIWindow) {
        self.window = window
        self.navController = UINavigationController()
    }
    
    // MARK: - Start Method
    func start() {
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
#warning("Тут сбрасываю юзердефолтс")
//        AppServices.shared.authService.logout()
//        AppServices.shared.localSessionStore.clearAll()
       makeAuthCoordinator()
    }
}
  
// MARK: - CoordinatorFactory
extension AppCoordinator: AuthCoordinatorFactory, RegistrationCoordinatorFactory, MainCoordinatorFactory {
    func makeAuthCoordinator() {
        let coordinator = AuthCoordinator(navController: navController, factory: self)
        
        coordinator.onFinish = {[weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.removeChild(coordinator)
        }
        
        addChild(coordinator)
        coordinator.start()
    }
    
    func makeRegistrationCoordinator() {
        let coordinator = RegistrationCoordinator(
            navController: navController,
            factory: self,
            localSessionStore: AppServices.shared.localSessionStore,
            authService: AppServices.shared.authService
        )
        
        coordinator.onFinish = {[weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.removeChild(coordinator)
        }
        
        addChild(coordinator)
        coordinator.start()
    }
    
    func makeMainCoordinator() {
        let coordinator = MainCoordinator(navController: navController, factory: self)
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.removeChild(coordinator)
        }
        
        addChild(coordinator)
        
        coordinator.start()
    }
}

