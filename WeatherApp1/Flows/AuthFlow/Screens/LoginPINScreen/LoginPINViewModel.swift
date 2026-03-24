//
//  LoginPINViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 23.03.2026.
//

import Foundation

struct LoginPINCodeViewState: Equatable {
    var enteredPin: String = ""
    var errorMessage: String?
    var attemptsCount: Int = 3
    var alertTitle: String?
    
    var enteredDigits: Int {
        enteredPin.count
    }
}

protocol LoginPINCodeViewInput {
    func didTapNumberButton(_ text: String)
    func didTapClearLastNumber()
    func didTapForgotPIN()
    func didTapFaceID()
    func didTapAlertButton()
}

protocol LoginPINCodeViewOutput {
    var onStateChange: ((LoginPINCodeViewState) -> Void)? { get set }
    var onMainFlow: (() -> Void)? { get set }
    var onAuthScreen: (() -> Void)? { get set }
    var onShowAlert: ((LoginPINCodeViewState) -> Void)? { get set }
}

final class LoginPINViewModel: LoginPINCodeViewInput, LoginPINCodeViewOutput {

   
    // Outputs
    var onStateChange: ((LoginPINCodeViewState) -> Void)?
    var onMainFlow: (() -> Void)?
    var onAuthScreen: (() -> Void)?
    var onShowAlert: ((LoginPINCodeViewState) -> Void)?
    
    let isFaceIDEnabled: Bool
    
    //DI
    private let localSession: LocalSessionStoreProtocol
    private let biometricService: BiomerticAuthServiceProtocol
    
    // State
    private var state = LoginPINCodeViewState() {
        didSet { onStateChange?(state) }
    }
    
    init(localSession: LocalSessionStoreProtocol, biometricService: BiomerticAuthServiceProtocol) {
        self.localSession = localSession
        self.biometricService = biometricService
        self.isFaceIDEnabled = localSession.isBiometricEnabled()
    }
    
    func didTapNumberButton(_ text: String) {
        guard state.enteredPin.count < 4 else { return }
        guard text.count == 1 else { return }
        
        state.errorMessage = nil
        state.enteredPin += text
        
        validatePin()
    }
    
    func didTapClearLastNumber() {
        guard !state.enteredPin.isEmpty else { return }
        state.enteredPin.removeLast()
    }
    
    func didTapFaceID() {
        validateFaceId()
    }
    
    func didTapForgotPIN() {
        state.alertTitle = "Вы будете перенаправлены на экран авторизации"
        onShowAlert?(state)
    }
    
    func didTapAlertButton() {
        localSession.clearPIN()
        onAuthScreen?()
    }
}

private extension LoginPINViewModel {
    
    func validatePin() {
        guard state.enteredPin.count == 4 else { return }
        
        if localSession.getPin() == state.enteredPin {
            onMainFlow?()
        } else {
            state.attemptsCount -= 1
            state.enteredPin = ""
            
            if state.attemptsCount <= 0 {
                state.errorMessage = nil
                state.alertTitle = "Вы совершили слишком много попыток входа"
                onShowAlert?(state)
            } else {
                state.errorMessage = "Неверный PIN. Осталось \(state.attemptsCount) попытки"
            }
        }
    }
    
    func validateFaceId() {
        biometricService.authenticate(reason: "Validate FaceId") { [weak self]  result in
            
            guard let self else { return }
            
            switch result {
            case .success():
                self.onMainFlow?()
            case .failure(_):
                print("pum")
            }
        }
    }
}
