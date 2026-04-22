//
//  AuthService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import FirebaseFirestore

protocol AuthServiceProtocol {
    var hasSession: Bool { get }
    
    func login(
        userName: String,
        password: String,
        completion: @escaping(Result<User, Error>) -> Void)
    
    func register(
        userName: String,
        password: String,
        completion: @escaping(Result<User, Error>) -> Void)
    
    func isLoginExists(
        _ userName: String,
        completion: @escaping(Result<Bool, Error>) -> Void)
    
    func logout()
}

final class FireStoreAuthService: AuthServiceProtocol {
    
    // MARK: - Constants
    private enum Constants {
            static let usersCollection = "users"
            static let idField = "id"
            static let loginField = "login"
            static let passwordField = "password"
        }
    
    // MARK: - DI
    private let db: Firestore
    private let sessionService: LocalSessionStoreProtocol
    
    // MARK: - Init
    init(
        db: Firestore = Firestore.firestore(),
        sessionService: LocalSessionStoreProtocol
    ) {
        self.db = db
        self.sessionService = sessionService
    }
    
    var hasSession: Bool {
        sessionService.isAuthorized
    }
    
    // MARK: - Public Methods
    func isLoginExists(
        _ userName: String,
        completion: @escaping (Result<Bool, any Error>) -> Void) {
        db.collection(Constants.usersCollection)
            .whereField(Constants.loginField, isEqualTo: userName)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                let exists = !(snapshot?.documents.isEmpty ?? true)
                completion(.success(exists))
            }
    }
    
    func register(
        userName: String,
        password: String,
        completion: @escaping (Result<User, any Error>) -> Void) {
            
        let userId = UUID().uuidString
        
        let data: [String: Any] = [
            Constants.idField: userId,
            Constants.loginField: userName,
            Constants.passwordField: password
        ]
        
        db.collection(Constants.usersCollection)
            .document(userId)
            .setData(data) { error in
                if let error {
                    completion(.failure(error))
                    return
                }
                
                let user = User(id: userId, login: userName)
                self.sessionService.saveSession(userId: user.id)
                completion(.success(user))
        }
    }
    
    func login(
        userName: String,
        password: String,
        completion: @escaping (Result<User, any Error>) -> Void) {
            
            db.collection(Constants.usersCollection)
                .whereField(Constants.loginField, isEqualTo: userName)
                .limit(to: 1)
                .getDocuments { [weak self] snapshot, error in
                    guard let self else { return }
                    
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let document = snapshot?.documents.first else {
                        completion(.failure(AuthError.invalidCredentials))
                        return
                    }
                    
                    let data = document.data()
                    
                    let storedPassword = data[Constants.passwordField] as? String
                    let storedId = data[Constants.idField] as? String ?? document.documentID
                    let storedLogin = data[Constants.loginField] as? String ?? userName
                    
                    guard storedPassword == password else {
                        completion(.failure(AuthError.invalidCredentials))
                        return
                    }
                    
                    let user = User(id: storedId, login: storedLogin)
                    self.sessionService.saveSession(userId: user.id)
                    completion(.success(user))
                }
            
    }
    
    func logout() {
        sessionService.clearSession()
    }
    
}


enum AuthError: Error {
    case userAlreadyExists
    case invalidCredentials
}



