//
//  PinDeleteButton.swift
//  WeatherApp
//
//  Created by Олег Зуев on 16.03.2026.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

final class PinDeleteButton: UIButton {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PinDeleteButton {
    // MARK: - Setup UI
    func setupUI() {
        setImage(UIImage(resource: .pinDeleteButton), for: .normal)
        tintColor = UIColor(.inactiveButton)
        configuration = nil
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 64, height: 36))
        }
    }
}
