//
//  AuthService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation

protocol AuthServiceProtocol {
    var hasSession: Bool { get }
    
    func login(userName: String, password: String, completion: @escaping(Result<User, Error>) -> Void)
    
    func register(userName: String, password: String, completion: @escaping(Result<User, Error>) -> Void)
    
    func logout()
}

final class AuthServiceMock: AuthServiceProtocol {
    
    private let queue = DispatchQueue(label: "auth.label.mock", qos: .userInitiated)
    
    private var users: [String: String] = ["1234" : "1234"] // username + password типа имитация ответа от сервера
    private var sessionUser: User? = nil
    
    var hasSession: Bool { sessionUser != nil  }
    //TODO Настройить реальные овтеты сервера
    func register(userName: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        queue.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self else { return }
            
            if self.users[userName] != nil {
                DispatchQueue.main.async {
                    completion(.failure(AuthError.userAlreadyExists))
                }
                return
            }
        
            self.users[userName] = password
            
            let user = User(id: UUID().uuidString, username: userName)
            self.sessionUser = user
        
            DispatchQueue.main.async {
                completion(.success(user))
            }
        }
    }
    
    func login(userName: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        queue.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self else { return }
            
            if self.users[userName] != password {
                DispatchQueue.main.async {
                    completion(.failure(AuthError.invalidCredentials))
                }
                return
            }
            
            let user = User(id: UUID().uuidString, username: userName)
            self.sessionUser = user
            
            DispatchQueue.main.async {
                completion(.success(user))
            }
        }
    }
    
    func logout() {
        self.sessionUser = nil
    }
}


enum AuthError: Error {
    case userAlreadyExists
    case invalidCredentials
}



