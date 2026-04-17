//
//  ForecastNDay.swift
//  WeatherApp
//
//  Created by Олег Зуев on 01.04.2026.
//

import UIKit
import SnapKit

final class WeeklyForecastView: UIView {
    // MARK: - UI
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    
    // MARK: - Private properties
    private let countOfDayForecast = 10
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        addFadeGradient()
    }
    
    // MARK: - Configure (Public)
    func configure(
        daysForecast: [DayForecast],
        currentDate: Date) {
            stackView.arrangedSubviews.forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            
            let sortedWeekForecast = daysForecast
                .sorted { $0.date < $1.date }
                .prefix(countOfDayForecast)
            
            sortedWeekForecast.forEach { dayForecast in
                let view = ForecastDayView()
                view.configure(dailyForecast: dayForecast, localDate: currentDate)
                
                stackView.addArrangedSubview(view)
            }
        }
}

private extension WeeklyForecastView {
    // MARK: - UI
    func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        scrollView.decelerationRate = .fast
        scrollView.showsVerticalScrollIndicator = false
        
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
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

    }
    
    // MARK: - Gradient
    func addFadeGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = scrollView.frame
        gradient.colors = [
            UIColor(white: 0, alpha: 0).cgColor,
            UIColor(white: 0, alpha: 1).cgColor,
            UIColor(white: 0, alpha: 1).cgColor,
            UIColor(white: 0, alpha: 0).cgColor
        ]
        gradient.locations = [0, 0.1, 0.9, 1.0]
        layer.mask = gradient
    }
    
}
