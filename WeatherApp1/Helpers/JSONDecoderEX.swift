//
//  JSONDecoderEX.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.04.2026.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(from data: Data) throws -> T {
        return try decode(T.self, from: data)
    }
}
