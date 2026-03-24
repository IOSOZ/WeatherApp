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
    
    // Outputs
    var onStateChange: ((RegisterUsernameViewState) -> Void)?
    var onNextStep: ((String) -> Void)?
    var onBackToAuth: (() -> Void)?
    
    //State
    private var state = RegisterUsernameViewState() {
        didSet { onStateChange?(state)}
    }
    
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
        let usernameOK = state.username.count >= 4 && state.username.count <= 20
        state.errorMessage = !usernameOK && !state.username.isEmpty ? "Количество символов от 4 до 20" : nil
        state.isNextStepEnabled = usernameOK
    }
}
