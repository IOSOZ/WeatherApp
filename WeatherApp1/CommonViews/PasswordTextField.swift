//
//  passwordTextField.swift
//  WeatherApp
//
//  Created by Олег Зуев on 04.03.2026.
//

import Foundation

import UIKit
import SnapKit


final class PasswordFieldView: UIView {
    
    // MARK: - UI Properties
    
    private let textField = PaddedTextField(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
    private let eyeButton = UIButton(type: .custom)
    private let textPlaceHolder: String
    
    // MARK: - Public API
    
    var text: String? {
        textField.text
    }
    var onTextChanged: ((String) -> Void)?
    
    
    // MARK: - Init
    
    init(textPlaceHolder: String) {
        self.textPlaceHolder = textPlaceHolder
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
        setupActions()
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension PasswordFieldView {
    
    func setupUI() {
        
        backgroundColor = UIColor(cgColor: .init(red: 243/255, green: 244/255, blue: 248/255, alpha: 1))
        layer.cornerRadius = 8
        clipsToBounds = true
        
        textField.placeholder = textPlaceHolder
        textField.isSecureTextEntry = true
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.smartQuotesType = .no
        textField.smartDashesType = .no
        textField.textContentType = .password
        
        eyeButton.tintColor = UIColor(cgColor: .init(red: 0, green: 26/255, blue: 52/255, alpha: 0.5))
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.backgroundColor = .clear
        
        addSubview(textField)
        addSubview(eyeButton)
    }
    
    func setupLayout() {
        textField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(eyeButton.snp.leading).offset(-8)
        }
        
        eyeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    func setupActions() {
        eyeButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
}

private extension PasswordFieldView {
    @objc func togglePassword() {
        eyeButton.isSelected.toggle()
        
        
        let wasFirstResponder = textField.isFirstResponder
        let currentText = textField.text
        
        textField.isSecureTextEntry.toggle()
        textField.text = currentText
        
        if wasFirstResponder {
            textField.becomeFirstResponder()
        }
    }
    
    @objc func textChanged() {
        onTextChanged?(textField.text ?? "")
    }
}

//#Preview {
//    PasswordFieldView()
//}
