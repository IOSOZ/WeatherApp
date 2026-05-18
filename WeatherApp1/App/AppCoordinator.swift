//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import UIKit


//enum AppFlow {
//    case auth
//    case registration
//    case main
//}
//
//protocol AppFlowOutput: AnyObject {
//    func requestAppFlow(_ flow: AppFlow, from coordinator: Coordinator)
//}

final class AppCoordinator: Coordinator {

    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Navigation
    private let window: UIWindow
    private let navController: UINavigationController
    
    // MARK: - Factory
    private let factory: AppCoordinatorFactoryProtocol
    
    // MARK: - Init
    init( window: UIWindow) {
        self.window = window
        self.navController = UINavigationController()
        self.factory = AppCoordinatorFactory()
    }
    
    // MARK: - Start Method
    func start() {
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
#warning("Тут сбрасываю инофрмацию о пользователе на устройстве")
//        AppServices.shared.authService.logout()
//        AppServices.shared.localSessionStore.clearAll()
        
#warning("для полноценной работы заменить строку ниже showAuthFlow()")
       showTabBarFlow()
    }
}


// MARK: - Output Implementation
extension AppCoordinator: AuthCoordinatorOutput, RegistrationCoordinatorOutput, TabBarCoordinatorOutput {
    func requestAuthFlow() {
        showAuthFlow()
    }
    
    func requestRegistrationFlow() {
        showRegistrationFlow()
    }
    
    func requestTabBarFlow() {
        showTabBarFlow()
    }
    
}

// MARK: - Create and Start Flow
private extension AppCoordinator {
    func showAuthFlow() {

        let coordinator = factory.makeAuthCoordinator(
            navController: navController,
            output: self
        )

        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.removeChild(coordinator)
        }

        addChild(coordinator)
        coordinator.start()
    }

    func showRegistrationFlow() {

        let coordinator = factory.makeRegistrationCoordinator(
            navController: navController,
            output: self
        )

        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.removeChild(coordinator)
        }

        addChild(coordinator)
        coordinator.start()
    }

    func showTabBarFlow() {
        let tabBarController = UITabBarController()
        
        navController.isNavigationBarHidden = true
        navController.setViewControllers([tabBarController], animated: true)

        let coordinator = factory.makeTabBarCoordinator(
            tabBarController: tabBarController,
            output: self,
            factory: TabBarCoordinatorFactory()
        )

        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            coordinator.clearAndStopAllChildCoordinators()
            self.removeChild(coordinator)
        }

        addChild(coordinator)
        coordinator.start()
    }
}
