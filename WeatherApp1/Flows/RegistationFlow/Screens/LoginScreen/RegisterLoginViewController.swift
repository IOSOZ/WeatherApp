//
//  RegisterPasswordViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 10.03.2026.
//

import UIKit
import SnapKit
import SwiftUI

class RegisterLoginViewController: UIViewController {

    // MARK: - UI
    private let titleLabel = UILabel()
    private let loginField = LoginFieldView()
    private let forwardButton = UIButton(type: .system)
    private let authorizeLabel = UILabel()
    private let authorizeTapLabel = UILabel()
    private let errorLabel = UILabel()
    
    private let upperStack = UIStackView()
    private let authorizeStack = UIStackView()
    private let bottomStack = UIStackView()
    
    private var bottomConstraint: Constraint?
    
    // MARK: - VM
    private let viewModel: RegisterUsernameViewModel
    
    // MARK: - Init
    init(viewModel: RegisterUsernameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Регистрация"
        
        setupUI()
        setupLayout()
        setupActions()
        bindViewModel()
        setupKeyboardHandling()
    }
    
}

private extension RegisterLoginViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        // MARK: - Stacks
        upperStack.axis = .vertical
        upperStack.spacing = 24
        
        bottomStack.axis = .vertical
        bottomStack.spacing = 16
        bottomStack.alignment = .center
        
        authorizeStack.axis = .horizontal
        authorizeStack.spacing = 4
        authorizeStack.alignment = .center
        authorizeStack.isUserInteractionEnabled = true
        
        // MARK: - Labels
        titleLabel.text = "Придумайте логин"
        titleLabel.font = UIFont(name: "SFPro-Semibold", size: 24)
        titleLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        
        authorizeLabel.text = "У вас уже есть аккаунт?"
        authorizeLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        authorizeLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        
        authorizeTapLabel.text = "Авторизуйтесь"
        authorizeTapLabel.textColor = .systemBlue
        authorizeTapLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        authorizeTapLabel.isUserInteractionEnabled = true
        authorizeTapLabel.underline()
        
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true
        errorLabel.text = "Такой логин уже сущетвует"
        
        forwardButton.isEnabled = false
        forwardButton.setTitle("Вперед", for: .normal)
        forwardButton.titleLabel?.font = UIFont(name: "SFPro-Bold", size: 16)
        forwardButton.layer.cornerRadius = 8
        forwardButton.backgroundColor = UIColor(.inactiveButton)
        forwardButton.setTitleColor(UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 0.5), for: .disabled)
        forwardButton.setTitleColor(UIColor(.white), for: .normal)
        
        // MARK: -  Add Views
        view.addSubview(upperStack)
        view.addSubview(bottomStack)
       
        upperStack.addArrangedSubview(titleLabel)
        upperStack.addArrangedSubview(loginField)
        upperStack.addArrangedSubview(errorLabel)
        
        authorizeStack.addArrangedSubview(authorizeLabel)
        authorizeStack.addArrangedSubview(authorizeTapLabel)
        
        bottomStack.addArrangedSubview(forwardButton)
        bottomStack.addArrangedSubview(authorizeStack)
    }
    
    // MARK: -  Setup Layout
    func setupLayout() {
        upperStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        bottomStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24).constraint
        }
        
        forwardButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(loginField)
        }
        
        loginField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
}

private extension RegisterLoginViewController {
    
    func setupActions() {
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        
        let authTap = UITapGestureRecognizer(target: self, action: #selector(didTapBackToAuth))
        authorizeTapLabel.addGestureRecognizer(authTap)
        
        loginField.onTextChanged = { [weak self] text in
            self?.viewModel.didChangeUserName(text)
        }
    }
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }
    
    func render(_ state: RegisterUsernameViewState) {
        forwardButton.isEnabled = state.isNextStepEnabled
        forwardButton.backgroundColor = forwardButton.isEnabled ? UIColor(.appBlue) : UIColor(.inactiveButton)
        
        if let error = state.errorMessage, !error.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = error
        } else {
            errorLabel.isHidden = true
            errorLabel.text = nil
        }
    }

    
    
    @objc func didTapForward() {
        viewModel.didTapNextStep()
    }
    
    @objc func didTapBackToAuth() {
        viewModel.didTapBackToAuth()
    }
    
}

// MARK: - Keyboard setup

private extension RegisterLoginViewController {
    func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillChangeFrame(_ note: Notification) {
        
        guard
            let userInfo = note.userInfo,
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
        else { return }
        
        let keyboardFrame = view.convert(endFrame, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY)
        
        let safeBottom = view.safeAreaInsets.bottom
        let bottomOffset = overlap > 0 ? -(overlap - safeBottom + 8) : -24
        
        bottomConstraint?.update(offset: bottomOffset)
        
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
}



//#Preview {
//    RegisterLoginViewController(viewModel: RegisterUsernameViewModel())
//}
