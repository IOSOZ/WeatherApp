//
//  ForecastHourView.swift
//  WeatherApp
//
//  Created by Олег Зуев on 31.03.2026.
//

import UIKit
import SnapKit

final class ForecastHourView: UIView {
    
    // MARK: - UI
    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Private Properties
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
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
    func configure(hourlyForecast: HourForecast) {
        timeLabel.text = formatter.string(from: hourlyForecast.date)
        tempLabel.text = "\(Int(hourlyForecast.temperature.rounded()))°"
        AppServices.shared.imageCacheService.loadImage(from: hourlyForecast.icon) { [weak self] image in
            self?.iconView.image = image
        }
    }
}

private extension ForecastHourView {
    // MARK: - Setup UI

    func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fill
        
        iconView.contentMode = .scaleAspectFit
        
        timeLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        tempLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        
        timeLabel.textColor = .white
        tempLabel.textColor = .white
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(tempLabel)
        
        addSubview(stackView)
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
}




