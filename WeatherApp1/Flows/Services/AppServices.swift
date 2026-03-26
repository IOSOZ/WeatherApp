//
//  File.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.03.2026.
//

import Foundation

final class AppServices {
    lazy var authService: AuthServiceProtocol = FireStoreAuthService(
        sessionService: sessionService)
    lazy var biometricAuthService: BiomerticAuthServiceProtocol = BiomerticAuthService()
    lazy var sessionService: SessionServiceProtocol = SessionService()
    lazy var localSessionStore: LocalSessionStoreProtocol = LocalSessionStore()
}
