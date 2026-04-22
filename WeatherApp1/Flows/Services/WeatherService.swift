//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation
import UIKit

protocol WeatherServiceProtocol {
    func getForecast(
        coordinates: Coordinates,
        days: Int) async throws -> Forecast
}

// обязательно возвращать на мейн поток, я это делаю чрез Combain
final class WeatherForecastService: WeatherServiceProtocol {
    
    private let apiKey = "72da43dcecda4de0bc3144840263003"
    private let network = NetworkService.shared
    
    func getForecast(coordinates: Coordinates, days: Int) async throws -> Forecast {
        
        var components = URLComponents(string: "https://api.weatherapi.com/v1/forecast.json")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: coordinates.strCoordinates),
            URLQueryItem(name: "days", value: String(days)),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no"),
            URLQueryItem(name: "lang", value: "ru")
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let response: WeatherResponse = try await network.request(url: url)
        return Forecast(dto: response)
    }
}



