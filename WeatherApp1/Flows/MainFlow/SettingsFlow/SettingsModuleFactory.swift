//
//  SettingsModuleFactory.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import Foundation
import UIKit

final class SettingsModuleFactory {
    func makeSettingsViewController(
        onFinish: @escaping () -> Void,
        onAuthFlow: @escaping (() -> Void)
    ) -> UIViewController {
        let viewModel = SettingsViewModel()
        
        viewModel.onFinish = onFinish
        viewModel.onAuthFlow = onAuthFlow
        
        let viewController = SettingsViewController(viewModel: viewModel)
        return viewController
    }
}
