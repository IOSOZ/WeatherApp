//
//  FaceIDViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 18.03.2026.
//

import UIKit
import SnapKit
import SwiftUI

class FaceIDViewController: UIViewController {

    // MARK: - UI
    private let titleLabel = UILabel()
    
    private let faceIDLabel = UILabel()
    private let switchControl = UISwitch()
    private let switchStack = UIStackView()
    
    private let forwardButton = UIButton(type: .system)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let authorizeLabel = UILabel()
    private let authorizeTapLabel = UILabel()
    private let authorizeStack = UIStackView()
    
    private let overlayView = UIView()
//    private let faceIDAlert = FaceIDAlertView()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    
    // MARK: - VM
    private let viewModel: FaceIDViewModel
    
    init(viewModel: FaceIDViewModel) {
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
    }
}

private extension FaceIDViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        // MARK: - Stacks
        switchStack.axis = .horizontal
        switchStack.distribution = .fill
        switchStack.isUserInteractionEnabled = true
        
        authorizeStack.axis = .horizontal
        authorizeStack.spacing = 4
        authorizeStack.isUserInteractionEnabled = true
        
        // MARK: - Labels
        
        titleLabel.text = "Подключить Face ID"
        titleLabel.font = UIFont(name: "SFPro-Semibold", size: 24)
        titleLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        
        faceIDLabel.text = "Face ID"
        faceIDLabel.font = UIFont(name: "SFPro-Medium", size: 16)
        faceIDLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        
        authorizeLabel.text = "У вас уже есть аккаунт?"
        authorizeLabel.textColor = UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 1)
        authorizeLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        
        authorizeTapLabel.text = "Авторизуйтесь"
        authorizeTapLabel.textColor = .systemBlue
        authorizeTapLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        authorizeTapLabel.isUserInteractionEnabled = true
        authorizeTapLabel.underline()
        
        blurView.alpha = 0.96
        blurView.isHidden = true
    
        forwardButton.isEnabled = true
        forwardButton.setTitle("Зарегистрироваться", for: .normal)
        forwardButton.titleLabel?.font = UIFont(name: "SFPro-Bold", size: 16)
        forwardButton.layer.cornerRadius = 8
        forwardButton.backgroundColor = UIColor(.appBlue)
        forwardButton.setTitleColor(UIColor(red: 0/255, green: 26/255, blue: 52/255, alpha: 0.5), for: .disabled)
        forwardButton.setTitleColor(UIColor(.white), for: .normal)
        
        activityIndicator.hidesWhenStopped = true
        overlayView.isHidden = true
        
        navigationItem.title = "Регистрация"
       
        
        // MARK: - Add Views
        
        view.addSubview(titleLabel)
        view.addSubview(switchStack)
        view.addSubview(forwardButton)
        view.addSubview(authorizeStack)
        view.addSubview(blurView)
        view.addSubview(overlayView)
        view.addSubview(activityIndicator)
        
//        overlayView.addSubview(faceIDAlert)
        
        switchStack.addArrangedSubview(faceIDLabel)
        switchStack.addArrangedSubview(switchControl)
        
        authorizeStack.addArrangedSubview(authorizeLabel)
        authorizeStack.addArrangedSubview(authorizeTapLabel)
        
    }
    
    // MARK: -  Setup Layout
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        switchStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        authorizeStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
        
        forwardButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(authorizeStack.snp.top).offset(-16)
        }
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        
//        faceIDAlert.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupActions() {
        switchControl.addTarget(self, action: #selector(didSwitch(_:)), for: .valueChanged)
        
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        
        let authTap = UITapGestureRecognizer(target: self, action: #selector(didTapBackToAuth))
        authorizeTapLabel.addGestureRecognizer(authTap)
        
//        faceIDAlert.onPrimaryTap = { [weak self] in
//            self?.viewModel.didTapPrimaryPromptAction()
//        }
//        
//        faceIDAlert.onSecondaryTap = { [weak self] in
//            self?.viewModel.didTapSecondaryPromptAction()
//        }
    }
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }
    
    func render(_ state: FaceIDViewState) {
        switch state.mode {
        case .initial(let isEnabled):
            switchControl.setOn(isEnabled, animated: true)

            titleLabel.isHidden = false
            switchStack.isHidden = false
            forwardButton.isHidden = false
            authorizeStack.isHidden = false

            blurView.isHidden = true
            overlayView.isHidden = true
//            faceIDAlert.isHidden = true

            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true

        case .permissionPrompt:
            titleLabel.isHidden = false
            switchStack.isHidden = false
            forwardButton.isHidden = false
            authorizeStack.isHidden = false

            blurView.isHidden = false
//            overlayView.isHidden = false
//            faceIDAlert.isHidden = false

            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true

//            faceIDAlert.configure(
//                title: #"Face ID для “Liberty”"#,
//                message: "Расположите камеру под правильным углом",
//                primaryButtonTitle: "Продолжить",
//                secondaryButtonTitle: nil
//            )

        case .authError:
            titleLabel.isHidden = false
            switchStack.isHidden = false
            forwardButton.isHidden = false
            authorizeStack.isHidden = false

            blurView.isHidden = false
            overlayView.isHidden = false
//            faceIDAlert.isHidden = false

            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true

//            faceIDAlert.configure(
//                title: "Лицо не распознано",
//                message: "Повторите или отмените",
//                primaryButtonTitle: "Повторить Face ID",
//                secondaryButtonTitle: "Отменить"
//            )

        case .loading:
            view.subviews.forEach { $0.isHidden = true}
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    @objc func didTapForward() {
        viewModel.didTapNext()
    }

    @objc func didTapBackToAuth() {
        viewModel.didTapBackToAuth()
    }

    @objc func didSwitch(_ sender: UISwitch) {
        viewModel.didToggleFaceID(sender.isOn)
    }
}


