//
//  ForecastHourView.swift
//  WeatherApp
//
//  Created by Олег Зуев on 31.03.2026.
//

import UIKit
import SnapKit

final class ForecastHourView: UIView {
    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    private let stackView = UIStackView()
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
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
    
    func configure(hourlyForecast: HourForecast) {
        timeLabel.text = formatter.string(from: hourlyForecast.date)
        tempLabel.text = "\(Int(hourlyForecast.temperature.rounded()))°"
        loadIcon(from: hourlyForecast.icon)
    }
}

private extension ForecastHourView {
    func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        iconView.contentMode = .scaleAspectFit
        
        timeLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        tempLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(tempLabel)
        
        addSubview(stackView)
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    func loadIcon(from path: String) {
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
}




