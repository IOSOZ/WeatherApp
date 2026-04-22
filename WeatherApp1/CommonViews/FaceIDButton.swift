//
//  FaceIDButton.swift
//  WeatherApp
//
//  Created by Олег Зуев on 23.03.2026.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

final class FaceIDButton: UIButton {
    
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

private extension FaceIDButton {
    // MARK: - Setup UI
    func setupUI() {
        setImage(UIImage(resource: .faceID), for: .normal)
        tintColor = UIColor(.appBlue)
        configuration = nil
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 64, height: 36))
        }
        
        imageView?.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerX.equalToSuperview()
        }
    }
}
