//
//  Forecast24HoursView.swift
//  WeatherApp
//
//  Created by Олег Зуев on 31.03.2026.
//

import UIKit
import SnapKit

class Forecast24HoursView: UIView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let countHoursForecast = 24
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    func setupUI() {
        stackView.axis = .horizontal
        stackView.spacing = 12
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
            make.height.equalTo(scrollView.frameLayoutGuide)
        }
    }
}
