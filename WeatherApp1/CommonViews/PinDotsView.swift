//
//  PinDotsView.swift
//  WeatherApp
//
//  Created by Олег Зуев on 16.03.2026.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit


final class PinDotsView: UIView {
    // MARK: - UI
    private let stackView = UIStackView()
    private var dotViews: [UIView] = []
    
    // MARK: - Private Properties
    private let count: Int
    private let dotSize: CGFloat
    private let spacing: CGFloat
    
    // MARK: - Init
    init(count: Int = 4, dotSize: CGFloat = 24, spacing: CGFloat = 16) {
        self.count = count
        self.dotSize = dotSize
        self.spacing = spacing
        super.init(frame: .zero)
        
        setupUI()
        setupDots()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure(Public)
    func configure(filledCount: Int) {
        for (index, dot) in dotViews.enumerated() {
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 3) {
                dot.backgroundColor = index < filledCount
                ? UIColor(.appBlue)
                : UIColor(.inactiveButton)
                dot.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }
            
        }
    }
    
    func reset() {
        configure(filledCount: 0)
    }
    
    func showIncorrectAnimation() {
        dotViews.forEach { dot in
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 3) {
                dot.backgroundColor = .red
                dot.backgroundColor = .inactiveButton
                dot.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }
        }
    }
}

private extension PinDotsView {
    // MARK: - Setup UI
    
    func setupUI() {
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
    }
    
    // MARK: - Setup UI
    func setupDots() {
        for _ in 0..<count {
            let dotView = UIView()
            dotView.backgroundColor = UIColor(.inactiveButton)
            dotView.layer.cornerRadius = dotSize / 2
            dotView.clipsToBounds = true
            
            stackView.addArrangedSubview(dotView)
            dotViews.append(dotView)
            
            dotView.snp.makeConstraints { make in
                make.size.equalTo(dotSize)
            }
        }
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


