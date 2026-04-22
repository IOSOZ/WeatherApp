//
//  PinNumberButton.swift
//  WeatherApp
//
//  Created by Олег Зуев on 16.03.2026.
//

import Foundation
import UIKit
import SnapKit

final class PinNumberButton: UIControl {
    // MARK: - UI
    
    private let circleView = UIView()
    private let numberLabel = UILabel()
    
    // MARK: - Public Property
    var number: Int = 0 {
        didSet { numberLabel.text = "\(number)" }
    }
    
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

private extension PinNumberButton {
    // MARK: - Setup UI
    func setupUI() {
        self.addSubview(circleView)
        self.addSubview(numberLabel)
        
        circleView.backgroundColor = .clear
        circleView.layer.cornerRadius = 32
        
        numberLabel.font = UIFont(name: "SFPro-Medium", size: 40)
        numberLabel.textAlignment = .center
        numberLabel.textColor = .black
        circleView.isUserInteractionEnabled = false
        numberLabel.isUserInteractionEnabled = false
    }
        func setupLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(64)
        }

        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Setup Actions
    func setupActions() {
        self.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
    }
    
    // MARK: - OBJC Methods
    @objc func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.circleView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    @objc func touchUp() {
        UIView.animate(withDuration: 0.1, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3) {
            self.circleView.backgroundColor = .clear
            self.transform = .identity
        }
    }
}

