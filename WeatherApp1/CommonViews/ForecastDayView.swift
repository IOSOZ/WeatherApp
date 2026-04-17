//
//  File.swift
//  WeatherApp
//
//  Created by Олег Зуев on 01.04.2026.
//

import UIKit
import SnapKit


final class ForecastDayView: UIView {
    // MARK: - UI
    private let dateLabel = UILabel()
    private let dayOfTheWeekLabel = UILabel()
    private let iconView = UIImageView()
    private let dayTemperatureLabel = UILabel()
    private let nightTemperatureLabel = UILabel()
    
    private let dateStackView = UIStackView()
    private let temperatureStackView = UIStackView()
    private let weatherStackView = UIStackView()
    
    // MARK: - Formatters
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()
    
    private let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
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
    func configure(dailyForecast: DayForecast, localDate: Date) {
        
        dateLabel.text = dateFormatter.string(from: dailyForecast.date)
        dayOfTheWeekLabel.text = formattedTitle(for: dailyForecast.date, localDate: localDate)
        
        dayTemperatureLabel.text = "\(Int(dailyForecast.dayTemp.rounded()))°C"
        nightTemperatureLabel.text = "\(Int(dailyForecast.nightTemp.rounded()))°C"
        
        AppServices.shared.imageCacheService.loadImage(from: dailyForecast.icon) { [weak self] image in
            self?.iconView.image = image
        }
        
    }
}

private extension ForecastDayView {
    // MARK: - Setup UI
    func setupUI() {
        dateStackView.axis = .vertical
        dateStackView.spacing = 4
        dateStackView.alignment = .leading
        
        weatherStackView.axis = .vertical
        weatherStackView.spacing = 20
        weatherStackView.alignment = .leading
        weatherStackView.distribution = .fill
        
        temperatureStackView.axis = .horizontal
        temperatureStackView.spacing = 20
        temperatureStackView.distribution = .equalSpacing
        temperatureStackView.alignment = .center
        
        iconView.contentMode = .scaleAspectFit
        
        dateLabel.font = UIFont(name: "SFPro-Regular", size: 16)
        dateLabel.textColor = UIColor(white: 0, alpha: 0.5)
        
        dayOfTheWeekLabel.font = UIFont(name: "SFPro-Regular", size: 16)
        dayOfTheWeekLabel.textColor = .black
        
        dayTemperatureLabel.font = UIFont(name: "SFPro-Regular", size: 18)
        dayTemperatureLabel.textColor = .black
        
        nightTemperatureLabel.font = UIFont(name: "SFPro-Regular", size: 18)
        nightTemperatureLabel.textColor = UIColor(white: 0, alpha: 0.5)
        
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dayOfTheWeekLabel)
        
        
        temperatureStackView.addArrangedSubview(iconView)
        temperatureStackView.addArrangedSubview(dayTemperatureLabel)
        temperatureStackView.addArrangedSubview(nightTemperatureLabel)
        
        addSubview(dateStackView)
        addSubview(temperatureStackView)
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(50)

        }
        
        dateStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        temperatureStackView.snp.makeConstraints { make in
            make.centerY.equalTo(dateStackView.snp.centerY)
            make.trailing.equalToSuperview()
            make.leading.equalTo(snp.centerXWithinMargins)
        }
    }
    
    // MARK: - Helper
    func formattedTitle(for forecastDate: Date, localDate: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDate(forecastDate, inSameDayAs: localDate) {
            return "Сегодня"
        }
        
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: localDate),
           calendar.isDate(forecastDate, inSameDayAs: tomorrow) {
            return "Завтра"
        }
        
        return dayOfWeekFormatter.string(from: forecastDate)
    }
}
