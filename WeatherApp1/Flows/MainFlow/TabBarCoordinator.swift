//
//  MainCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation
import UIKit

protocol TabBarCoordinatorOutput: AnyObject {
    func requestAuthFlow()
}

//enum Tab: Int, CaseIterable {
//    case weather
//    case favorite
//    
//    var title: String {
//        switch self {
//        case .weather:
//            return "Погода"
//        case .favorite:
//            return "Избранное"
//        }
//    }
//}


final class TabBarCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    
    private weak var output: TabBarCoordinatorOutput?
    
    // MARK: - Factory
    private let factory: TabBarCoordinatorFactoryProtocol
    
    // MARK: - TabBarController
    private let tabBarController: UITabBarController
    
    // MARK: - Nested Coordinators
    var weatherCoordinator: WeatherCoordinator? {
        childCoordinators.first { $0 is WeatherCoordinator } as? WeatherCoordinator
    }
    var favoriteCoordinator: FavoriteCoordinator? {
        childCoordinators.first { $0 is FavoriteCoordinator } as? FavoriteCoordinator
    }
    
    // MARK: - Init
    init(tabBarController: UITabBarController, output: TabBarCoordinatorOutput, factory: TabBarCoordinatorFactoryProtocol) {
        self.output = output
        self.tabBarController = tabBarController
        self.factory = factory
    }
    
    // MARK: - Start Method
    func start() {
        makeWeatherCoordinator()
        makeFavoriteCoordinator()
        setupTabBar()
    }
}

private extension TabBarCoordinator {
    func setupTabBar () {
        
        guard let weatherCoordinator, let favoriteCoordinator else {
            return
        }
        
        weatherCoordinator.navBar.tabBarItem = UITabBarItem(
            title: "Погода",
            image: UIImage(
                systemName: "sun.horizon"
            ),
            selectedImage: UIImage(
                systemName: "sun.horizon.fill"
            )
        )
        
        favoriteCoordinator.navBar.tabBarItem = UITabBarItem(
            title: "Избарнное",
            image: UIImage(
                systemName: "star"
            ),
            selectedImage: UIImage(
                systemName: "star.fill"
            )
        )
        
        tabBarController.viewControllers = [
            weatherCoordinator.navBar,
            favoriteCoordinator.navBar
        ]
    }
}

// MARK: - Output Implementation
extension TabBarCoordinator: WeatherCoordinatorOutput, FavoriteCoordinatorOutput {
    func requestAuthCoordinator() {
        output?.requestAuthFlow()
        onFinish?()
    }
}

// MARK: - Create Flow
private extension TabBarCoordinator {

    func makeWeatherCoordinator()  {
        let navBar = UINavigationController()
        let coordinator = WeatherCoordinator(navBar: navBar, output: self, factory: WeatherCoordinatorFactory())
        
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return}
            self.removeChild(coordinator)
        }
        
        addChild(coordinator)
        coordinator.start()
        
    }
    
    func makeFavoriteCoordinator()  {
        let navBar = UINavigationController()
        let coordinator = FavoriteCoordinator(output: self, navBar: navBar)
        
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.removeChild(coordinator)
        }
        
        addChild(coordinator)
        coordinator.start()
        
    }
    
}
