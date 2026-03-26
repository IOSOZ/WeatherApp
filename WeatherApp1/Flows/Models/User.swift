//
//  File.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation


struct User: Codable {
    let id: String
    let login: String
}


struct RegistrationDraft {
    var username: String?
    var password: String?
    var pin: String?
    var isFaceIDEnabled: Bool?
}
