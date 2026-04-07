//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation

enum WeatherForecastError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case emptyData
}


protocol WeatherServiceProtocol {
    func getForecast(
        coordinates: Coordinates,
        days: Int,
        completion: @escaping (Result<Forecast, Error>) -> Void
    )
}

final class WeatherForecastService: WeatherServiceProtocol {
    
    private let apiKey = "72da43dcecda4de0bc3144840263003"
    private let session = URLSession.shared
    
    func getForecast(coordinates: Coordinates, days: Int, completion: @escaping (Result<Forecast, any Error>) -> Void) {
        
        var components = URLComponents(string: "https://api.weatherapi.com/v1/forecast.json")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: coordinates.strCoordinates),
            URLQueryItem(name: "days", value: String(days)),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no")
        ]
        
        guard let url = components?.url else {
            completion(.failure(WeatherForecastError.invalidURL))
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
                    completion(.failure(WeatherForecastError.invalidResponse))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(WeatherForecastError.httpError(httpResponse.statusCode)))
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(WeatherForecastError.emptyData))
                }
                return
            }
            
            do {
                let decodeResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                let forecast = Forecast(dto: decodeResponse)
                
                DispatchQueue.main.async {
                    completion(.success(forecast))
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
