//
//  CitySearchService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation

protocol CitySearchServiceProtocol {
    func searchCities(text: String) async throws -> [CitySuggestion]
}

final class CitySearchService: CitySearchServiceProtocol {
    
    private let apiKey = "0df7b4b85cc04863b811996d565ce427"
    private let network = NetworkService.shared
    
    func searchCities(text: String) async throws -> [CitySuggestion] {
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            return []
        }
        
        var components = URLComponents(string: "https://api.geoapify.com/v1/geocode/autocomplete")
        components?.queryItems = [
            URLQueryItem(name: "text", value: trimmedText),
            URLQueryItem(name: "type", value: "city"),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let response: GeoapifyAutocompleteResponse = try await network.request(url: url)
        
        let suggestions = response.results.map {
            CitySuggestion(dto: $0)
        }
        
        return suggestions
    }
}
