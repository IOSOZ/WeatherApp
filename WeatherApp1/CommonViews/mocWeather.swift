//
//  moWeather.swift
//  WeatherApp
//
//  Created by Олег Зуев on 10.04.2026.
//

import Foundation

final class MockWeatherService: WeatherServiceProtocol {
    func getForecast(coordinates: Coordinates, days: Int, completion: @escaping (Result<Forecast, Error>) -> Void) {
        
        let now = Date()
        
        let current = CurrentWeather(
            date: now,
            temperature: 17,
            icon: "//cdn.weatherapi.com/weather/64x64/day/116.png",
            description: "Местами облачно",
            feelLikeTemp: 15,
            windSpeed: 4,
            humidity: 84,
            pressure: 1017,
            isDay: true
        )
        
        let hourForecast = (0..<24).map { i in
            HourForecast(
                date: now.addingTimeInterval(TimeInterval(i * 3600)),
                temperature: Double(17 - i / 3),
                icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
            )
        }
        
        let weeklyForecast = (0..<10).map { i in
            DayForecast(
                date: Calendar.current.date(byAdding: .day, value: i, to: now)!,
                dayTemp: Double(17 - i),
                nightTemp: Double(10 - i),
                icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
            )
        }
        
        let forecast = Forecast(
            localDate: now,
            current: current,
            hourForecast: hourForecast,
            weeklyForecast: weeklyForecast
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(forecast))
        }
    }
}
