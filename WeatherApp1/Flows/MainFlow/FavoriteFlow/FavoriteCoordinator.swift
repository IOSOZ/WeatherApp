//
//  FavoriteCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import Foundation
import UIKit

protocol FavoriteCoordinatorOutput: AnyObject {
    // Тут заложена архитектура, но функционал не реализован
}

final class FavoriteCoordinator: Coordinator {
    
    // MARK: - Flow Work
    var childCoordinators: [any Coordinator] = []
    
    var onFinish: (() -> Void)?
    
    private weak var output: FavoriteCoordinatorOutput?
    private let moduleFactory = FavoriteModuleFactory()
    
    // MARK: - NavBar
    let navBar: UINavigationController
    
    // MARK: - Init
    init(output: FavoriteCoordinatorOutput, navBar: UINavigationController) {
        self.output = output
        self.navBar = navBar
    }
    
    func start() {
       showFavoriteScreen()
    }
}

private extension FavoriteCoordinator {
    func showFavoriteScreen() {
        let vc = moduleFactory.makeFavoriteViewController()
        navBar.setViewControllers([vc], animated: false)
    }
}
