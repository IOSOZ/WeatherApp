//
//  BiomerticAuthService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 18.03.2026.
//

import Foundation
import LocalAuthentication

protocol BiomerticAuthServiceProtocol {
    func authenticate(
        reason: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class BiomerticAuthService: BiomerticAuthServiceProtocol {
    func authenticate(reason: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error) else {
            completion(.failure(error ?? NSError(domain: "Biometry", code: -1)))
            return
        }
        
        
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(error ?? NSError(domain: "Biometry", code: -2)))
                }
            }
        }
    }
    
}




