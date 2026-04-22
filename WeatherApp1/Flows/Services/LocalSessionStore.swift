//
//  LocalSessionStore.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.03.2026.
//

import Foundation
import Security

protocol LocalSessionStoreProtocol {
    var hasPin: Bool { get }
    var isAuthorized: Bool { get }
    
    func savePin(_ pin: String)
    func getPin() -> String?
    func verifyPin(_ pin: String) -> Bool
        
    func setBiometricEnabled(_ isEnabled: Bool)
    func isBiometricEnabled() -> Bool
    
    func saveSession(userId: String)
    func getUserId() -> String?
    func clearSession()
    
}

final class LocalSessionStore: LocalSessionStoreProtocol {
    
    private enum Keys {
        static let pin = "local_session.pin"
        static let biometricEnabled = "local_session.biometric_enabled"
        static let userIdKey = "session.userId"
    }

    // MARK: - Protocol Implementatin
    
    var isAuthorized: Bool {
        getUserId() != nil
    }
    
    func saveSession(userId: String) {
        save(userId, forKey: Keys.userIdKey)
    }
    
    func getUserId() -> String? {
        get(forKey: Keys.userIdKey)
    }
    
    func clearSession() {
        delete(forKey: Keys.biometricEnabled)
        delete(forKey: Keys.pin)
        delete(forKey: Keys.userIdKey)
    }
    
    var hasPin: Bool {
        getPin() != nil
    }
    
    func savePin(_ pin: String) {
        save(pin, forKey: Keys.pin)
    }
    
    func getPin() -> String? {
        get(forKey: Keys.pin)
    }
    
    func verifyPin(_ pin: String) -> Bool {
        getPin() == pin
    }
    
    func setBiometricEnabled(_ isEnabled: Bool) {
        saveBool(isEnabled, forKey: Keys.biometricEnabled)
    }
    
    func isBiometricEnabled() -> Bool {
        getBool(forKey: Keys.biometricEnabled)
    }
}
// MARK: - Keychain Helpers
private extension LocalSessionStore {
    
    func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    func saveBool(_ value: Bool, forKey key: String) {
        save(value ? "1" : "0", forKey: key)
    }
    
    func getBool(forKey key: String) -> Bool {
        get(forKey: key) == "1"
    }
    
}
