//
//  LoginPINViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 23.03.2026.
//

import UIKit
import SnapKit
import Combine

class LoginPINViewController: UIViewController {

    // MARK: - UI
    private let logoImageView = UIImageView()
    private var titleLabel = UILabel()
    private let pinDotView = PinDotsView()
    private let errorLabel = UILabel()
    private let forgotPIN = UILabel()
    private let keyboardView: PinKeyboardView
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let titleStack = UIStackView()
    private let pinStack = UIStackView()
    
    // MARK: - VM
    private let viewModel: LoginPINViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: LoginPINViewModel) {
        self.viewModel = viewModel
        self.keyboardView = PinKeyboardView(needFaceId: viewModel.isFaceIDEnabled)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupActions()
        bindViewModel()
    }
}

// MARK: - Extension

private extension LoginPINViewController {
    func setupUI() {
        
        view.backgroundColor = .white
        // Stacks
        titleStack.axis = .vertical
        titleStack.spacing = 24
        titleStack.alignment = .center
        
        pinStack.axis = .vertical
        pinStack.spacing = 16
        pinStack.alignment = .center
        pinStack.isUserInteractionEnabled = true
        
        // Logo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(resource: .logo)
        
        blurView.alpha = 0.96
        blurView.isHidden = false
        
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Face ID или PIN-код"
        
        errorLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        errorLabel.textColor = .red
        errorLabel.isHidden = false
        
        forgotPIN.font = UIFont(name: "SFPro-Regular", size: 16)
        forgotPIN.textColor = . systemBlue
        forgotPIN.isUserInteractionEnabled = true
        forgotPIN.underline()
        forgotPIN.text = "Забыли PIN-код?"
        keyboardView.apply(enteredSymbols: 0)
        
        // Add Views
        view.addSubview(blurView)
        view.addSubview(logoImageView)
        
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(pinDotView)
        
        view.addSubview(titleStack)
        view.addSubview(errorLabel)
        
        pinStack.addArrangedSubview(forgotPIN)
        pinStack.addArrangedSubview(keyboardView)
        
        view.addSubview(pinStack)
    }
    
    func setupLayout() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(106)
            make.height.equalTo(124)
        }
        
        titleStack.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        pinStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(64)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    func setupActions() {
        keyboardView.onDigitTap = { [weak self] digit in
            self?.viewModel.didTapNumberButton(digit)
            
        }
        
        keyboardView.onDeleteTap = { [weak self] in
            self?.viewModel.didTapClearLastNumber()
        }
        
        keyboardView.onFaceIDTap = { [weak self] in
            self?.viewModel.didTapFaceID()
        }
        
        let forgotPINTap = UITapGestureRecognizer(target: self, action: #selector(didTapForgotPIN))
        forgotPIN.addGestureRecognizer(forgotPINTap)
    }
    
    func bindViewModel() {
        viewModel.$state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        viewModel.showAlert.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.showAlert(state)
            }
            .store(in: &cancellables)
        }
    
    func render(_ state: LoginPINCodeViewState) {
        pinDotView.configure(filledCount: state.enteredDigits)
        errorLabel.isHidden = state.errorMessage == nil
        errorLabel.text = state.errorMessage
        keyboardView.apply(enteredSymbols: state.enteredDigits)
    }
    
    func showAlert(_ state: LoginPINCodeViewState) {
        let alert = UIAlertController(
            title: state.alertTitle,
            message: "Пожалуйства введите логин и пароль",
            preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Понятно", style: .default) { [weak self] _ in
            self?.blurView.isHidden = true
            self?.viewModel.didTapAlertButton()
        }
        alert.addAction(okButton)
        self.blurView.isHidden = false
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapForgotPIN() {
        viewModel.didTapForgotPIN()
    }
}

