//
//  File.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation


struct User: Equatable {
    let id: String
    let username: String
}


struct RegistrationDraft {
    var username: String?
    var password: String?
    var pin: String?
    var isFaceIDEnabled: Bool?
}
