//
//  PinCodeViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 16.03.2026.
//

import Foundation
import Combine

enum PinCodeStage {
    case creation
    case confirmation(firstPinCode: String)
}

struct PinCodeViewState: Equatable {
    var title: String = ""
    var enteredPin: String = ""
    var errorMessage: String?
    
    var enteredDigits: Int {
        enteredPin.count
    }
}

protocol PinCodeViewInput {
    func didTapNumberButton(_ text: String)
    func didTapClearLastNumber()
}


final class PinCodeViewModel: PinCodeViewInput {
   
    // MARK: - Outputs
    var onNextStep: ((String) -> Void)?
    
    // MARK: - State
    private var stage: PinCodeStage = .creation
    
    @Published var state = PinCodeViewState(title: "Придумайте PIN-код")
    
    // MARK: - Setup Logic
    func didTapNumberButton(_ text: String) {
        guard state.enteredPin.count < 4 else { return }
        guard text.count == 1 else { return }
        
        state.errorMessage = nil
        state.enteredPin += text
        
        validate()
    }
    
    func didTapClearLastNumber() {
        guard !state.enteredPin.isEmpty else { return }
        state.enteredPin.removeLast()
    }
}

private extension PinCodeViewModel {
    // MARK: - Validation
    func validate() {
        guard state.enteredPin.count == 4 else { return }
        
        switch stage {
            
        case .creation:
            let firstPin = state.enteredPin
            
            stage = .confirmation(firstPinCode: firstPin)
            state.title = "Подтвердите PIN-код"
            state.enteredPin = ""
            state.errorMessage = nil
        case .confirmation(firstPinCode: let firstPinCode):
            if state.enteredPin == firstPinCode {
                onNextStep?(state.enteredPin)
                stage = .creation
                state.enteredPin = ""
                state.title = "Придумайте PIN-код"
            } else {
                state.enteredPin = ""
                state.errorMessage = "PIN-код не совпадает"
            }
        }
    }
}
