//
//  AppDIContainer.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation

final class AppDIContainer {
    let services: AppServices
    
    init(appServices: AppServices) {
        self.services = appServices
    }
    
    
}
