//
//  Forecast24HoursView.swift
//  WeatherApp
//
//  Created by Олег Зуев on 31.03.2026.
//

import UIKit
import SnapKit

class Forecast24HoursView: UIView {
    // MARK: - UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // MARK: -  Private Properties
    private let countHoursForecast = 24
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        addFadeGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure (Public)
    func configure(
        dayForecast: [HourForecast],
        currentDate: Date) {
            stackView.arrangedSubviews.forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            
            let sortedDayForecast = dayForecast
                .filter { $0.date > currentDate }
                .sorted { $0.date < $1.date }
                .prefix(countHoursForecast)
            
            sortedDayForecast.forEach { hourlyForecast in
                let view = ForecastHourView()
                view.configure(hourlyForecast: hourlyForecast)
                
                stackView.addArrangedSubview(view)
            }
        }
}

private extension Forecast24HoursView {
    // MARK: - Setup UI
    func setupUI() {
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        scrollView.decelerationRate = .fast
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    // MARK: - Setup Layout
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    // MARK: - Gradient
    func addFadeGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = scrollView.frame
        gradient.colors = [
            UIColor.appBlue.withAlphaComponent(0).cgColor,
            UIColor.appBlue.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0.05, y: 0)
        layer.mask = gradient
    }
}
