//
//  RegisterPasswordViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 10.03.2026.
//

import Foundation

struct RegisterUsernameViewState: Equatable {
    var username: String = ""
    var isNextStepEnabled: Bool = false
    var errorMessage: String?
}


protocol RegisterUsernameInput {
    func didChangeUserName(_ text: String)
    func didTapNextStep()
    func didTapBackToAuth()
}

protocol RegisterUsernameOutput {
    var onStateChange: ((RegisterUsernameViewState) -> Void)? { get set}
    var onNextStep: ((String) -> Void)? { get set }
    var onBackToAuth: (() -> Void)? { get set }
}

final class RegisterUsernameViewModel: RegisterUsernameInput, RegisterUsernameOutput {
    
    // MARK: - Outputs
    var onStateChange: ((RegisterUsernameViewState) -> Void)?
    var onNextStep: ((String) -> Void)?
    var onBackToAuth: (() -> Void)?
    
    // MARK: - DI
    private let authService: AuthServiceProtocol
    
    // MARK: - State
    private var state = RegisterUsernameViewState() {
        didSet { onStateChange?(state)}
    }
    
    // MARK: - Init
    init( authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    // MARK: - Setup Logic
    func didChangeUserName(_ text: String) {
        state.username = text
        validate()
    }
    
    func didTapNextStep() {
        guard state.isNextStepEnabled else { return }
        onNextStep?(state.username)
    }
    
    func didTapBackToAuth() {
        onBackToAuth?()
    }
    
}

private extension RegisterUsernameViewModel {
    func validate() {
        
        let username = state.username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameOK = username.count >= 4 && username.count <= 20
        
        state.isNextStepEnabled = false
        
        guard !username.isEmpty else {
            state.errorMessage = nil
            return
        }
        
        guard usernameOK else {
            state.errorMessage = "Количество символов от 4 до 20"
            return
        }
        
        authService.isLoginExists(username) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let isExist):
                self.state.errorMessage = isExist ? "Такой пользователь уже существует" : nil
                self.state.isNextStepEnabled = !isExist
                
            case .failure(let error):
                print(error)
                self.state.errorMessage = "Не удалось проверить логин"
                self.state.isNextStepEnabled = false
            }
        }
    }
}
