//
//  ForecastNDay.swift
//  WeatherApp
//
//  Created by Олег Зуев on 01.04.2026.
//

import UIKit
import SnapKit

class WeeklyForecastView: UIView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let countOfDayForecast = 7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
}
