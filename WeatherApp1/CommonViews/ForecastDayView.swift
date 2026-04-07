//
//  File.swift
//  WeatherApp
//
//  Created by Олег Зуев on 01.04.2026.
//

import UIKit
import SnapKit


final class ForecastDayView: UIView {
    private let dateLabel = UILabel()
    private let dayOfTheWeekLabel = UILabel()
    private let iconView = UIImageView()
    private let dayTemperatureLabel = UILabel()
    private let nightTemperatureLabel = UILabel()
    
    private let dateStackView = UIStackView()
    private let weatherStackView = UIStackView()
    
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dailyForecast: DayForecast, localDate: Date) {
        dateLabel.text = formattedTitle(for: dailyForecast.date, localDate: localDate)
        dayOfTheWeekLabel.text = dayOfWeekFormatter.string(from: dailyForecast.date)
        dayTemperatureLabel.text = "\(Int(dailyForecast.dayTemp.rounded()))°"
        nightTemperatureLabel.text = "\(Int(dailyForecast.nightTemp.rounded()))°"
        
        iconView.image = nil
        loadIcon(form: dailyForecast.icon)
        
    }
}

private extension ForecastDayView {
    func setupUI() {
        dateStackView.axis = .vertical
        dateStackView.spacing = 4
        dateStackView.alignment = .leading
        
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 20
        weatherStackView.alignment = .center
        weatherStackView.distribution = .fill
        
        iconView.contentMode = .scaleAspectFit
        
        dateLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        dateLabel.textColor = UIColor(white: 0, alpha: 0.5)
        
        dayOfTheWeekLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        dayOfTheWeekLabel.textColor = .black
        
        dayTemperatureLabel.font = UIFont(name: "SFPro-Regular", size: 16)
        dayTemperatureLabel.textColor = .black
        
        nightTemperatureLabel.font = UIFont(name: "SFPro-Regular", size: 16)
        nightTemperatureLabel.textColor = UIColor(white: 0, alpha: 0.5)
        
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dayOfTheWeekLabel)
        
        weatherStackView.addArrangedSubview(iconView)
        weatherStackView.addArrangedSubview(dayTemperatureLabel)
        weatherStackView.addArrangedSubview(nightTemperatureLabel)
        
        addSubview(dateStackView)
        addSubview(weatherStackView)
    }
    
    func setupLayout() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        weatherStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func loadIcon(form path: String) {
        let fullPath = path.hasPrefix("http") ? path : "https:\(path)"
        
        guard let url = URL(string: fullPath) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self,
                let data,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.iconView.image = image
            }
        }.resume()
    }
    
    func formattedTitle(for forecastDate: Date, localDate: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDate(forecastDate, inSameDayAs: localDate) {
            return "Сегодня"
        }
        
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: localDate),
           calendar.isDate(forecastDate, inSameDayAs: tomorrow) {
            return "Завтра"
        }
        
        return dateFormatter.string(from: forecastDate)
    }
}
