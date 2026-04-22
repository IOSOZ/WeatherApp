//
//  CitySuggestion.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
    
    var strCoordinates: String {
        "\(latitude),\(longitude)"
    }
}

struct GeoapifyCityDTO: Decodable {
    let city: String?
    let country: String?
    let formatted: String?
    let lat: Double
    let lon: Double
}

struct GeoapifyAutocompleteResponse: Decodable {
    let results: [GeoapifyCityDTO]
}

struct CitySuggestion {
    let title: String
    let coordinates: Coordinates
}

extension CitySuggestion {
    init(dto: GeoapifyCityDTO) {
        self.title = dto.formatted ?? dto.city ?? "Неизвестный город"
        self.coordinates = Coordinates(latitude: dto.lat, longitude: dto.lon)
    }
}
