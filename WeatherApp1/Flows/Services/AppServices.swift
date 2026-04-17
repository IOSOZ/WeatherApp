//
//  File.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.03.2026.
//

import Foundation

final class AppServices {
    
    static let shared = AppServices()
    
    lazy var authService: AuthServiceProtocol = FireStoreAuthService(
        sessionService: sessionService)
    lazy var biometricAuthService: BiomerticAuthServiceProtocol = BiomerticAuthService()
    lazy var sessionService: SessionServiceProtocol = SessionService()
    lazy var localSessionStore: LocalSessionStoreProtocol = LocalSessionStore()
    lazy var citySearchService: CitySearchService = CitySearchService()
    lazy var locationService: LocationService = LocationService()
    lazy var weatherService: WeatherForecastService = WeatherForecastService()
    lazy var imageCacheService: ImageCacheService = ImageCacheService()
    
    private init() {}
}
