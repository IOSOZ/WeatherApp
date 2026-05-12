//
//  FavoriteModuleFactory.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import Foundation
import UIKit

final class FavoriteModuleFactory {
    func makeFavoriteViewController() -> UIViewController {
        let viewModel = FavoriteViewModel()
        let viewController = FavoriteViewController(viewModel: viewModel)
        return viewController
    }
}
