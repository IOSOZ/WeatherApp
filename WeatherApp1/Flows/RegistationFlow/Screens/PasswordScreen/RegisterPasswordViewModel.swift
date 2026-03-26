//
//  RegisterPasswordViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 11.03.2026.
//

import Foundation

struct PasswordCheck: Equatable {
    var lengthCheck: Bool = false
    var lowerAndUpperCase: Bool = false
    var specialCharacters: Bool = false
    var allowedCharactersOnly: Bool = false
    var digitCheck: Bool = false
    let isTest: Bool = true
}

struct RegisterPasswordViewState: Equatable {
    var firstPassword: String = ""
    var secondPassword: String = ""
    var isNextStepEnabled: Bool = false
    var passwordCheck = PasswordCheck()
}

protocol RegisterPasswordInput {
    func didChangeFirstPassword(_ text: String)
    func didChangeSecondPassword(_ text: String)
    func didTapNextStep()
    func didTapBackToAuth()
}

protocol RegisterPasswordOutput {
    var onStateChange: ((RegisterPasswordViewState) -> Void)? { get set }
    var onNextStep: ((String) -> Void)? { get set }
    var onBackToAuth: (() -> Void)? { get set }
}

final class RegisterPasswordViewModel: RegisterPasswordInput, RegisterPasswordOutput {

    // MARK: - Outputs
    var onStateChange: ((RegisterPasswordViewState) -> Void)?
    var onNextStep: ((String) -> Void)?
    var onBackToAuth: (() -> Void)?


    // MARK: - State
    private var state = RegisterPasswordViewState() {
        didSet { onStateChange?(state) }
    }

    // MARK: - Setup Logic
    func didChangeFirstPassword(_ text: String) {
        state.firstPassword = text
        validate()
    }

    func didChangeSecondPassword(_ text: String) {
        state.secondPassword = text
        validate()
    }

    func didTapNextStep() {
        guard state.isNextStepEnabled else { return }
        onNextStep?(state.firstPassword)
    }

    func didTapBackToAuth() {
        onBackToAuth?()
    }
}

private extension RegisterPasswordViewModel {

    func validate() {
        let password = state.firstPassword

        let allowedSpecials = "!@#&%^*()-_+;:,.?/\\|`~{}[]<>=\"'$%"
        let allowedCharacters = CharacterSet.letters
            .union(.decimalDigits)
            .union(CharacterSet(charactersIn: allowedSpecials))

        let hasValidLength = password.count >= 6 && password.count <= 20
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasDigit = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecial = password.range(
            of: "[" + NSRegularExpression.escapedPattern(for: allowedSpecials) + "]",
            options: .regularExpression
        ) != nil

        let containsOnlyAllowedCharacters =
            password.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }

        if state.passwordCheck.isTest {
            state.passwordCheck.lengthCheck = true
            state.passwordCheck.lowerAndUpperCase = true
            state.passwordCheck.digitCheck = true
            state.passwordCheck.specialCharacters = true
            state.passwordCheck.allowedCharactersOnly = true
        } else {
            state.passwordCheck.lengthCheck = hasValidLength
            state.passwordCheck.lowerAndUpperCase = hasLowercase && hasUppercase
            state.passwordCheck.digitCheck = hasDigit
            state.passwordCheck.specialCharacters = hasSpecial
            state.passwordCheck.allowedCharactersOnly = containsOnlyAllowedCharacters
        }
        
      

        let allChecksPassed =
            state.passwordCheck.lengthCheck &&
            state.passwordCheck.lowerAndUpperCase &&
            state.passwordCheck.digitCheck &&
            state.passwordCheck.specialCharacters &&
            state.passwordCheck.allowedCharactersOnly

        let passwordsMatch =
            !state.firstPassword.isEmpty &&
            state.firstPassword == state.secondPassword

        state.isNextStepEnabled = allChecksPassed && passwordsMatch
    }
}
