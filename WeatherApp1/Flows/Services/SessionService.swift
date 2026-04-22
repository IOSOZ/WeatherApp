//
//  SessionService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 22.03.2026.
//

//import Foundation
//
//protocol SessionServiceProtocol {
//    var isAuthorized: Bool { get }
//    
//    func saveSession(userId: String)
//    func getUserId() -> String?
//    func clearSession()
//}
//
//
//final class SessionService: SessionServiceProtocol {
//    private let userIdKey = "session.userId"
//    
//    var isAuthorized: Bool {
//        getUserId() != nil
//    }
//    
//    func saveSession(userId: String) {
//        UserDefaults.standard.set(userId, forKey: userIdKey)
//    }
//    
//    func getUserId() -> String? {
//        UserDefaults.standard.string(forKey: userIdKey)
//    }
//    
//    func clearSession() {
//        UserDefaults.standard.removeObject(forKey: userIdKey)
//    }
//}
