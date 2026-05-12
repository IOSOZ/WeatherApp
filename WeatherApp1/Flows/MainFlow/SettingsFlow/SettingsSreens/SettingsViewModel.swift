//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 07.05.2026.
//

import Foundation

protocol SettingsViewModelInput {
    func didTapBackOnTabFlow()
}

final class SettingsViewModel: SettingsViewModelInput {
    // MARK: - Outputs
    var onFinish: (() -> Void)?
    var onAuthFlow: (() -> Void)?
    
    // MARK: - Setup Logic
    func didTapBackOnTabFlow() {
        onFinish?()
    }
    
    func didTapLogOut() {
        onAuthFlow?()
        onFinish?()
    }
}
