//
//  LocalSessionStore.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.03.2026.
//

import Foundation

protocol LocalSessionStoreProtocol {
    var hasPin: Bool { get }
    
    func savePin(_ pin: String)
    func getPin() -> String?
    func verifyPin(_ pin: String) -> Bool
        
    func setBiometricEnabled(_ isEnabled: Bool)
    func isBiometricEnabled() -> Bool
    
    func clearPIN()
    func clearAll()
}

final class LocalSessionStore: LocalSessionStoreProtocol {
    
    private enum Keys {
        static let pin = "local_session.pin"
        static let biometricEnabled = "local_session.biometric_enabled"
    }

    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var hasPin: Bool {
        getPin() != nil
    }
    
    func savePin(_ pin: String) {
        defaults.set(pin, forKey: Keys.pin)
    }
    
    func getPin() -> String? {
        defaults.string(forKey: Keys.pin)
    }
    
    func verifyPin(_ pin: String) -> Bool {
        getPin() == pin
    }
    
    func setBiometricEnabled(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: Keys.biometricEnabled)
    }
    
    func isBiometricEnabled() -> Bool {
        defaults.bool(forKey: Keys.biometricEnabled)
    }
    
    func clearPIN() {
        defaults.removeObject(forKey: Keys.pin)
    }
    
    func clearAll() {
        defaults.removeObject(forKey: Keys.pin)
        defaults.removeObject(forKey: Keys.biometricEnabled)
    }
    
}
