//
//  loginTextField.swift
//  WeatherApp
//
//  Created by Олег Зуев on 04.03.2026.
//

import Foundation
import UIKit
import SnapKit

final class LoginFieldView: UIView {
    
    // MARK: - UI Properties
    private let textField = PaddedTextField(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
    private let cancelButton = UIButton(type: .custom)
    
    // MARK: - Public API
    
    var text: String? {
        textField.text
    }
    var onTextChanged: ((String) -> Void)?
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension LoginFieldView {
    // MARK: - Setup UI

    func setupUI() {
        backgroundColor = UIColor(cgColor: .init(red: 243/255, green: 244/255, blue: 248/255, alpha: 1))
        layer.cornerRadius = 8
        clipsToBounds = true
        
        textField.placeholder = "Логин"
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.smartQuotesType = .no
        textField.smartDashesType = .no
        textField.textContentType = .username
        
        cancelButton.tintColor = UIColor(cgColor: .init(red: 0, green: 26/255, blue: 52/255, alpha: 0.5))
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.isHidden = true
        
        addSubview(textField)
        addSubview(cancelButton)
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        textField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(cancelButton.snp.leading).offset(-8)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    // MARK: - Setup Actions
    func setupActions() {
        cancelButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
}

// MARK: - OBJC Methods
private extension LoginFieldView {
    @objc func clearTextField() {
        textField.text = ""
        cancelButton.isHidden = true
        
        let wasFirstResponder = textField.isFirstResponder
        if wasFirstResponder {
            textField.becomeFirstResponder()
        }
        onTextChanged?("")
    }
    
    @objc func textChanged() {
        cancelButton.isHidden = (textField.text ?? "").isEmpty
        onTextChanged?(textField.text ?? "")
    }
}

//#Preview {
//    LoginFieldView()
//}
