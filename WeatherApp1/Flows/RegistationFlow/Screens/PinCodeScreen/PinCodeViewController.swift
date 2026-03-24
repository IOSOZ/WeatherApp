//
//  PinCodeViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 16.03.2026.
//

import UIKit
import SnapKit

class PinCodeViewController: UIViewController {

    // MARK: - UI
    private var titleLabel = UILabel()
    private let pinDotView = PinDotsView()
    private let errorLabel = UILabel()
    private let keyboardView = PinKeyboardView(needFaceId: false)
    private let contentStack = UIStackView()
    
    // MARK: - VM
    private let viewModel: PinCodeViewModel
    
    // MARK: - Init
    init(viewModel: PinCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
        setupActions()
        bindViewModel()
    }
}

private extension PinCodeViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Регистрация"
        
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.alignment = .center
        
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Придумайте PIN-код"
        
        errorLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        errorLabel.text = "PIN-код не совпадает"
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        
        view.addSubview(contentStack)
        view.addSubview(errorLabel)
        view.addSubview(keyboardView)
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(pinDotView)
    }
    
    func setupLayout() {
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(123)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(contentStack.snp.bottom).offset(16)
            make.centerX.equalTo(contentStack)
            
        }
        
        keyboardView.snp.makeConstraints { make in
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
    }
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }
    func render(_ state: PinCodeViewState) {
        pinDotView.configure(filledCount: state.enteredDigits)
        titleLabel.text = state.title
        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil
    }
}
//
//#Preview {
//    PinCodeViewController(viewModel: PinCodeViewModel())
//}
