//
//  LoginViewController2.swift
//  WeatherApp
//
//  Created by Олег Зуев on 04.03.2026.
//

import UIKit
import SnapKit
import SwiftUI
import Combine

class LoginViewController: UIViewController {

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoImageView = UIImageView()
    
    private let contentStack = UIStackView()
    private let titleStack = UIStackView()
    private let helloLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let loginField = LoginFieldView()
    private let passwordField = PasswordFieldView(textPlaceHolder: "Пароль")
    
    private let errorLabel = UILabel()
    private let bottomStack = UIStackView()
    private let forwardButton = UIButton(type: .system)
    
    private let registerStack = UIStackView()
    private let registerLabel = UILabel()
    private let registerTapLabel = UILabel()
    
    private var bottomConstraint: Constraint?
    
    // MARK: - VM
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: LoginViewModel) {
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

// MARK: - Extension
private extension LoginViewController {
    func setupUI() {
        
        view.backgroundColor = .white
        
        scrollView.isScrollEnabled = true
        scrollView.keyboardDismissMode = .interactive
        
        // Logo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(resource: .logo)
        
        // Staccks
        contentStack.axis = .vertical
        contentStack.spacing = 16
        titleStack.axis = .vertical
        titleStack.spacing = 8
        registerStack.axis = .horizontal
        registerStack.spacing = 4
        registerStack.alignment = .center
        registerStack.isUserInteractionEnabled = true
        
        // Labels
        helloLabel.text = "Привет !"
        helloLabel.font = UIFont(name: "SFPro-Bold", size: 32)
        helloLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        
        subtitleLabel.text = "Войдите в LIB Weather"
        subtitleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        subtitleLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.85
        subtitleLabel.lineBreakMode = .byClipping
        
        // Error
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.text = "Неверный логин или пароль"
        
        // Bottom
        bottomStack.axis = .vertical
        bottomStack.spacing = 16
        
        forwardButton.isEnabled = false
        forwardButton.setTitle("Вперед", for: .normal)
        forwardButton.titleLabel?.font = UIFont(name: "SFPro-Bold", size: 16)
        forwardButton.layer.cornerRadius = 8
        forwardButton.backgroundColor = UIColor(.inactiveButton)
        forwardButton.setTitleColor(UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 0.5), for: .disabled)
        forwardButton.setTitleColor(UIColor(.white), for: .normal)
        
        registerLabel.text = "У вас нет аккаунта?"
        registerLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        registerLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        
        registerTapLabel.text = "Зарегестрируйстесь"
        registerTapLabel.textColor = .systemBlue
        registerTapLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        registerTapLabel.isUserInteractionEnabled = true
        registerTapLabel.underline()
        
        
        // Add Views
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)

        contentView.addSubview(logoImageView)
        contentView.addSubview(contentStack)
        contentView.addSubview(forwardButton)
        contentView.addSubview(registerStack)
        
        titleStack.addArrangedSubview(helloLabel)
        titleStack.addArrangedSubview(subtitleLabel)
        
        contentStack.addArrangedSubview(titleStack)
        contentStack.addArrangedSubview(loginField)
        contentStack.addArrangedSubview(passwordField)
        contentStack.addArrangedSubview(errorLabel)
        
        registerStack.addArrangedSubview(registerLabel)
        registerStack.addArrangedSubview(registerTapLabel)
    }
    
    // MARK: -  Setup Layout
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(106)
            make.height.equalTo(124)
        }
        
        forwardButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(contentStack.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
        
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        registerStack.snp.makeConstraints { make in
            make.top.equalTo(forwardButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        
        loginField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        passwordField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
}

// MARK: - Setup Actions
private extension LoginViewController {
    
    func setupActions() {
        forwardButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(didTapRegister))
        registerTapLabel.addGestureRecognizer(registerTap)
        
        loginField.onTextChanged = { [weak self] text in
            self?.viewModel.didChangeUsername(text)
        }
        
        passwordField.onTextChanged = { [weak self] text in
            self?.viewModel.didChangePassword(text)
        }
    }
    
    func bindViewModel() {
        viewModel.$state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
    
    @objc func didTapRegister() {
        viewModel.didTapRegister()
    }
    
    @objc func didTapLogin() {
        viewModel.didTapLogin()
    }
    
    func render(_ state: LoginViewState) {
        forwardButton.isEnabled = state.isLoginEnabled && !state.isLoading
        forwardButton.backgroundColor = forwardButton.isEnabled ? UIColor(.appBlue) : UIColor(.inactiveButton)
        
        if let error = state.errorMessage, !error.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = error
        } else {
            errorLabel.isHidden = true
            errorLabel.text = nil
        }
    }
}


// MARK: - Keyboard setup
private extension LoginViewController {
    
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
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        let keyboardFrame = view.convert(endFrame, from: nil)
        
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY)
        
        scrollView.isScrollEnabled = overlap > 0
        
        scrollView.contentInset.bottom = overlap
        scrollView.verticalScrollIndicatorInsets.bottom = overlap
    }
}


//#Preview {
//    LoginViewController2(viewModel: LoginViewModel(authService: AuthServiceMock() as AuthService))
//}
