//
//  FaceIDAlertController.swift
//  WeatherApp
//
//  Created by Олег Зуев on 18.03.2026.
//

import UIKit
import SnapKit

class FaceIDAlertView: UIView {
    // MARK: - Actions
    var onPrimaryTap: (() -> Void)?
    var onSecondaryTap: (() -> Void)?
    
    // MARK: - UI
    private let containerView = UIView()
    
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
   
    private let textStack = UIStackView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    private let buttonStack = UIStackView()
    private let primaryButton = UIButton(type: .system)
    private let secondaryButton = UIButton(type: .system)
    
    private let primarySeparator = UIView()
    private let secondarySeparator = UIView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupHierarchy()
        setupLayout()
        setupActions()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String?
    ) {
        titleLabel.text = title
        messageLabel.text = message
        primaryButton.setTitle(primaryButtonTitle, for: .normal)
        
        if let secondaryButtonTitle {
            secondaryButton.isHidden = false
            secondarySeparator.isHidden = false
            secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
        } else {
            secondaryButton.isHidden = true
            secondarySeparator.isHidden = true
            secondaryButton.setTitle(nil, for: .normal)
        }
    }
}

private extension FaceIDAlertView {
    func setupUI() {
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        containerView.layer.cornerRadius = 14
        containerView.clipsToBounds = true
        iconContainerView.backgroundColor = .clear
        
        iconImageView.image = UIImage(systemName: "faceid")
        iconImageView.tintColor = UIColor(red: 117/255, green: 127/255, blue: 138/255, alpha: 1)
        iconImageView.contentMode = .scaleAspectFit
        
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.alignment = .fill
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.font = .systemFont(ofSize: 13, weight: .regular)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        buttonStack.axis = .vertical
        buttonStack.spacing = 0
        buttonStack.alignment = .fill
        buttonStack.distribution = .fill
        
        primaryButton.setTitleColor(.systemBlue, for: .normal)
        primaryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        secondaryButton.setTitleColor(.systemBlue, for: .normal)
        secondaryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        
        primarySeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.25)
        secondarySeparator.backgroundColor = UIColor(white: 0.3, alpha: 0.25)
    }
    
    func setupHierarchy() {
        addSubview(containerView)
        
        containerView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        
        containerView.addSubview(textStack)
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(messageLabel)
        
        containerView.addSubview(buttonStack)
        
        buttonStack.addArrangedSubview(primarySeparator)
        buttonStack.addArrangedSubview(primaryButton)
        buttonStack.addArrangedSubview(secondarySeparator)
        buttonStack.addArrangedSubview(secondaryButton)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
            make.size.equalTo(89)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(56)
        }
        
        textStack.snp.makeConstraints { make in
            make.top.equalTo(iconContainerView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(textStack.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        primarySeparator.snp.makeConstraints { make in
            make.height.equalTo(0.33)
        }
        
        primaryButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        secondarySeparator.snp.makeConstraints { make in
            make.height.equalTo(0.33)
        }
        
        secondaryButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    func setupActions() {
        primaryButton.addTarget(self, action: #selector(didTapPrimary), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(didTapSecondary), for: .touchUpInside)
    }
    
    @objc func didTapPrimary() {
        onPrimaryTap?()
    }
    
    @objc func didTapSecondary() {
        onSecondaryTap?()
    }
}

//#Preview {
//    FaceIDAlertView()
//}
