//
//  LoginViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation
import Combine

struct LoginViewState: Equatable {
    var username: String = ""
    var password: String = ""
    var isLoginEnabled: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
}

protocol LoginViewModelInput {
    func didChangeUsername(_ text: String)
    func didChangePassword(_ text: String)
    func didTapLogin()
    func didTapRegister()
}

final class LoginViewModel: LoginViewModelInput {
    
    // MARK: - Outputs
    var onLoginSuccess: (() -> Void)?
    var onRegister: (() -> Void)?
    var onChangePIN: (() -> Void)?
    
    // MARK: - DI
    private let authService: AuthServiceProtocol
    
    // MARK: - State
    @Published var state = LoginViewState()
    
    // MARK: - Init
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    // MARK: - Setup Logic
    func didChangeUsername(_ text: String) {
        state.username = text
        validate()
    }
    
    func didChangePassword(_ text: String) {
        state.password = text
        validate()
    }
    
    func didTapLogin() {
        
        guard state.isLoginEnabled, state.isLoading == false else { return }
        
        state.isLoading = true
        state.errorMessage = nil
        
        authService.login(userName: state.username, password: state.password) { [weak self] result in
            guard let self else { return }
            
            self.state.isLoading = false
            
            switch result {
            case .success:
                self.onLoginSuccess?()
            case .failure:
                self.state.errorMessage = "Неверный логин или пароль"
            }
        }
        
    }
    
    func didTapRegister() {
        onRegister?()
    }
    
    private func validate() {
        let usernameOK = !state.username.isEmpty
        let passwordOK = state.password.count >= 4
        
        state.isLoginEnabled = usernameOK && passwordOK
    }
    
}
