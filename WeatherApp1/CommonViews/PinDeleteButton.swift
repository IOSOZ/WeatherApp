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
    func setupUI() {
        setImage(UIImage(resource: .pinDeleteButton), for: .normal)
        tintColor = UIColor(.inactiveButton)
        configuration = nil
    }
    
    func setupLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 64, height: 36))
        }
    }
}
