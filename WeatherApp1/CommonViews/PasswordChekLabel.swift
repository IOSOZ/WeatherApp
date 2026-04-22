//
//  PasswordChekLabale.swift
//  WeatherApp
//
//  Created by Олег Зуев on 11.03.2026.
//

import Foundation
import UIKit
import SnapKit

final class PasswordCheckLabel: UIView {
    
    // MARK: - UI
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure (Public)
    func configure(text: String, isSatisfied: Bool) {
        titleLabel.text = text
        titleLabel.textColor = isSatisfied ? .systemGreen : .systemRed
        iconImageView.image = isSatisfied ? UIImage(resource: .chekMark) : UIImage(resource: .xmark)
        iconImageView.tintColor = isSatisfied ? .systemGreen : .systemRed
    }
}

private extension PasswordCheckLabel {

    // MARK: - Setup UI
    func setupUI() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center

        titleLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        titleLabel.numberOfLines = 0

        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
    }

    // MARK: - Setup Layout
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
}


