//
//  CitySearchService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation

enum CitySearchError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case emptyData
}

protocol CitySearchServiceProtocol {
    func searchCities(
        text: String,
        completion: @escaping (Result<[CitySuggestion], Error>) -> Void
    )
}

final class CitySearchService: CitySearchServiceProtocol {
    
    private let apiKey = "0df7b4b85cc04863b811996d565ce427"
    private let session = URLSession.shared
    
    func searchCities(
        text: String,
        completion: @escaping (Result<[CitySuggestion], Error>) -> Void
    ) {
       
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            completion(.success([]))
            return
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
            completion(.failure(CitySearchError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(CitySearchError.invalidResponse))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(CitySearchError.httpError(httpResponse.statusCode)))
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(CitySearchError.emptyData))
                }
                return
            }
            
            do {
                let decodeResponse = try JSONDecoder().decode(GeoapifyAutocompleteResponse.self, from: data)
                let suggestions = decodeResponse.results.map {
                    CitySuggestion(dto: $0)
                }
                
                DispatchQueue.main.async {
                    completion(.success(suggestions))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
