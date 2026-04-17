//
//  PinCodeViewController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 16.03.2026.
//

import UIKit
import SnapKit
import Combine

class PinCodeViewController: UIViewController {

    // MARK: - UI
    private var titleLabel = UILabel()
    private let pinDotView = PinDotsView()
    private let errorLabel = UILabel()
    private let keyboardView = PinKeyboardView(needFaceId: false)
    private let contentStack = UIStackView()
    
    // MARK: - VM
    private let viewModel: PinCodeViewModel
    private var cancellabels = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: PinCodeViewModel) {
        self.viewModel = viewModel
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

private extension PinCodeViewController {
    // MARK: - Setup UI
    func setupUI() {
        // MARK: - Views Setup
        view.backgroundColor = .white
        navigationItem.title = "Регистрация"
        
        // MARK: - Stacks Setup
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.alignment = .center
        
        // MARK: - Labels Setup
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Придумайте PIN-код"
        
        errorLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        errorLabel.text = "PIN-код не совпадает"
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        
        // MARK: - Add Views
        view.addSubview(contentStack)
        view.addSubview(errorLabel)
        view.addSubview(keyboardView)
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(pinDotView)
    }
    
    // MARK: - Setup Layout
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
    
    // MARK: - Setup Actions
    func setupActions() {
        keyboardView.onDigitTap = { [weak self] digit in
            self?.viewModel.didTapNumberButton(digit)
        }
        
        keyboardView.onDeleteTap = { [weak self] in
            self?.viewModel.didTapClearLastNumber()
        }
    }
    // MARK: - Bind ViewModel
    func bindViewModel() {
        viewModel.$state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }.store(in: &cancellabels)
    }
    // MARK: - Render
    func render(_ state: PinCodeViewState) {
        pinDotView.configure(filledCount: state.enteredDigits)
        titleLabel.text = state.title
        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil
    }
}
