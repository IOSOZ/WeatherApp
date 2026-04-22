//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.04.2026.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
}

// MARK: - Network Service
final class NetworkService {
    static let shared = NetworkService()
    private let session = URLSession.shared
    
    private init() {}

    
    func request<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func request(url: URL) async throws -> Data {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            return data
        }
}
