//
//  CoordinatorFactory.swift
//  WeatherApp
//
//  Created by Олег Зуев on 06.04.2026.
//

import Foundation

protocol CoordinatorFactory {
    func makeAuthCoordinator() -> Coordinator
    func makeRegistrationCoordinator() -> Coordinator
    func makeMainCoordinator() -> Coordinator
}
