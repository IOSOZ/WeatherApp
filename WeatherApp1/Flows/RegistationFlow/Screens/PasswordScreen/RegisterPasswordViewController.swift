//
//  RegisterPasswordViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 11.03.2026.
//

import UIKit
import SnapKit
import SwiftUI
import Combine

class RegisterPasswordViewController: UIViewController {

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let firstPasswordTF = PasswordFieldView(textPlaceHolder: "Пароль")
    private let secondPasswordTF = PasswordFieldView(textPlaceHolder: "Повторить пароль")
    
    private let forwardButton = UIButton(type: .system)
    
    private let authorizeLabel = UILabel()
    private let authorizeTapLabel = UILabel()
    private let authorizeStack = UIStackView()
    
    private let lengthCheckLabel = PasswordCheckLabel()
    private let lowerAndUpperCaseLabel = PasswordCheckLabel()
    private let specialCharactersLabel = PasswordCheckLabel()
    private let allowedCharactersOnlyLabel = PasswordCheckLabel()
    private let digitCheckLabel = PasswordCheckLabel()
    
    private let passwordCheckStack = UIStackView()
    
    private let fieldsStack = UIStackView()
    private var buttonBottomConstraint: Constraint?
    
    // MARK: - VM
    private let viewModel: RegisterPasswordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: RegisterPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupActions()
        bindViewModel()
        setupKeyboardHandling()
    }
}

private extension RegisterPasswordViewController {
    // MARK: - Setup UI
    func setupUI() {
        
        // MARK: - Views Setup
        view.backgroundColor = .white
        
        scrollView.isScrollEnabled = false
        scrollView.keyboardDismissMode = .interactive
        
        // MARK: - Navigation
        navigationItem.title = "Регистрация"
        
        // MARK: - Stacks Setup
        passwordCheckStack.axis = .vertical
        passwordCheckStack.spacing = 8
        passwordCheckStack.isHidden = true
        passwordCheckStack.alpha = 0
        
        authorizeStack.axis = .horizontal
        authorizeStack.spacing = 4
        authorizeStack.isUserInteractionEnabled = true
        
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 8

        
        // MARK: - Labels Setup
        titleLabel.text = "Придумайте пароль"
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
        
        forwardButton.isEnabled = false
        forwardButton.setTitle("Далее", for: .normal)
        forwardButton.titleLabel?.font = UIFont(name: "SFPro-Bold", size: 16)
        forwardButton.layer.cornerRadius = 8
        forwardButton.backgroundColor = UIColor(.inactiveButton)
        forwardButton.setTitleColor(UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 0.5), for: .disabled)
        forwardButton.setTitleColor(UIColor(.white), for: .normal)
        
        // MARK: -  Add Views
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(forwardButton)
        view.addSubview(authorizeStack)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(firstPasswordTF)
        contentView.addSubview(passwordCheckStack)
        contentView.addSubview(secondPasswordTF)
        contentView.addSubview(fieldsStack)

        fieldsStack.addArrangedSubview(firstPasswordTF)
        fieldsStack.addArrangedSubview(passwordCheckStack)
        fieldsStack.addArrangedSubview(secondPasswordTF)
        
        passwordCheckStack.addArrangedSubview(lengthCheckLabel)
        passwordCheckStack.addArrangedSubview(lowerAndUpperCaseLabel)
        passwordCheckStack.addArrangedSubview(digitCheckLabel)
        passwordCheckStack.addArrangedSubview(specialCharactersLabel)
        passwordCheckStack.addArrangedSubview(allowedCharactersOnlyLabel)
        
        authorizeStack.addArrangedSubview(authorizeLabel)
        authorizeStack.addArrangedSubview(authorizeTapLabel)
    }
    
    // MARK: -  Setup Layout
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(forwardButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        fieldsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        firstPasswordTF.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        secondPasswordTF.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        
        authorizeStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
        
        forwardButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            buttonBottomConstraint = make.bottom.equalTo(authorizeStack.snp.top).offset(-16).constraint
        }
    }
    
    // MARK: - Setup Actions
    func setupActions() {
        firstPasswordTF.onTextChanged = { [weak self] text in
            self?.viewModel.didChangeFirstPassword(text)
        }
        
        secondPasswordTF.onTextChanged = { [weak self] text in
            self?.viewModel.didChangeSecondPassword(text)
        }
        
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        
        let authTap = UITapGestureRecognizer(target: self, action:  #selector(didTapBackToAuth))
        authorizeTapLabel.addGestureRecognizer(authTap)
    }
    
    // MARK: - Bind ViewModel
    func bindViewModel() {
        viewModel.$state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Render
    func render(_ state: RegisterPasswordViewState) {
        forwardButton.isEnabled = state.isNextStepEnabled
        forwardButton.backgroundColor = state.isNextStepEnabled ? UIColor(.appBlue) : UIColor(.inactiveButton)
        
        let shouldShowChecks = !state.firstPassword.isEmpty
        passwordCheckStack.isHidden = !shouldShowChecks
        
        
        lengthCheckLabel.configure(
            text: "Количество символов от 6 до 20",
            isSatisfied: state.passwordCheck.lengthCheck
        )
        lowerAndUpperCaseLabel.configure(
            text: "Есть строчные и заглавные буквы",
            isSatisfied: state.passwordCheck.lowerAndUpperCase
        )
        digitCheckLabel.configure(
            text: "Есть цифры",
            isSatisfied: state.passwordCheck.digitCheck
        )
        
        let specialCharacters = #"Есть специальные символы ! # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _` { | } ~"#
        specialCharactersLabel.configure(
            text: specialCharacters,
            isSatisfied: state.passwordCheck.specialCharacters
        )
        let allowedCharacters = #"Используйте только буквы (a-z, A-Z), цифры и символы ! @ # & % ^ & * ( )- _ + ; : , . / ? \ | ` ~ {  }"#
        allowedCharactersOnlyLabel.configure(
            text: allowedCharacters,
            isSatisfied: state.passwordCheck.allowedCharactersOnly
        )
        
        UIView.animate(withDuration: 0.25) {
            self.passwordCheckStack.alpha = shouldShowChecks ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - OBJC Methods
    @objc func didTapForward() {
        viewModel.didTapNextStep()
    }
    
    @objc func didTapBackToAuth() {
        viewModel.didTapBackToAuth()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        
        let buttonOffset = overlap > 0 ? -(overlap - safeBottom - 16) : -8
        buttonBottomConstraint?.update(offset: buttonOffset)
        
        scrollView.isScrollEnabled = overlap > 0
        
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
}


private extension RegisterPasswordViewController {
    // MARK: - Keyboard
    func setupKeyboardHandling() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    
}

//#Preview {
//    RegisterPasswordViewController(viewModel: RegisterPasswordViewModel())
//}
