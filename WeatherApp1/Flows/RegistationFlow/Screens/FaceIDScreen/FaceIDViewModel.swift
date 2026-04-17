//
//  FaceIDViewMolde.swift
//  WeatherApp
//
//  Created by Олег Зуев on 18.03.2026.
//

import Foundation
import Combine

enum FaceIDScreenMode: Equatable {
    case initial(isEnabled: Bool)
    case permissionPrompt
    case authError
    case loading
}
  
struct FaceIDViewState: Equatable {
    var mode: FaceIDScreenMode = .initial(isEnabled: false)
    var screenTitle: String = "Подключить Face ID"
}

protocol FaceIDViewModelInput {
    func didToggleFaceID(_ isOn: Bool)
    func didTapNext()
    func didTapPrimaryPromptAction()
    func didTapSecondaryPromptAction()
    func didTapBackToAuth()
}

final class FaceIDViewModel: FaceIDViewModelInput {
    
    var onNextStep: ((Bool) -> Void)?
    var onBackToAuth: (() -> Void)?
    
    // MARK: - DI
    private let biomerticAuthService: BiomerticAuthServiceProtocol
    
    // MARK: - State
    @Published var state = FaceIDViewState()
    
    private var isFaceIDEnabled = false
    
    // MARK: - Init
    init(biomerticAuthService: BiomerticAuthServiceProtocol) {
        self.biomerticAuthService = biomerticAuthService
    }
    
    // MARK: - Setup Logic
    func didToggleFaceID(_ isOn: Bool) {
        if isOn {
            state.mode = .permissionPrompt
            authenticate()
        } else {
            isFaceIDEnabled = false
            state.mode = .initial(isEnabled: false)
        }
    }
    
    func didTapNext() {
        state.mode = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self else { return}
            self.onNextStep?(isFaceIDEnabled)
        }
        

    }
    
    func didTapPrimaryPromptAction() {
        switch state.mode {
        case .initial, .loading:
            break
        case .permissionPrompt:
            state.mode = .initial(isEnabled: false)
            isFaceIDEnabled = false
        case .authError:
            authenticate()
        }
    }
    
    func didTapSecondaryPromptAction() {
        state.mode = .initial(isEnabled: false)
        isFaceIDEnabled = false
    }
    
    func didTapBackToAuth() {
        onBackToAuth?()
    }
}

private extension FaceIDViewModel {
    
    // MARK: - Authenticate
    func authenticate() {
        biomerticAuthService.authenticate(reason: "TurnOn FaceId") { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success():
                self.isFaceIDEnabled = true
                self.state.mode = .initial(isEnabled: true)
            case .failure(_):
                self.isFaceIDEnabled = false
                self.state.mode = .authError
            }
        }
    }
}
