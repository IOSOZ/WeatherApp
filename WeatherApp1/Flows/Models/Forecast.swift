//
//  DayForecast.swift
//  WeatherApp
//
//  Created by Олег Зуев on 31.03.2026.
//

import Foundation

struct Forecast {
    let localDate: Date
    let current: CurrentWeather
    let hourForecast: [HourForecast]
    let weeklyForecast: [DayForecast]
}

struct CurrentWeather {
    let date: Date
    let temperature: Int
    let icon: String
    let description: String
    let feelLikeTemp:Int
    let windSpeed: Int
    let humidity: Int
    let pressure: Int
    let isDay: Bool
}

struct HourForecast {
    let date: Date
    let temperature: Double
    let icon: String
}

struct DayForecast {
    let date: Date
    let dayTemp: Double
    let nightTemp: Double
    let icon: String
}


struct WeatherResponse: Decodable {
    let location: LocationDTO
    let current: CurrentWeatherDTO
    let forecast: ForecastDTO
}

struct ForecastDTO: Decodable {
    let forecastday: [ForecastDayDTO]
}

struct ForecastDayDTO: Decodable {
    let date: String
    let day: DayDTO
    let hour: [HourForecastDTO]
}

struct CurrentWeatherDTO: Decodable {
    let date: String
    let temp: Double
    let condition: ConditionDTO
    let feelsLikeTemp: Double
    let windKpH: Double
    let humidity: Int
    let pressureMB: Double
    let isDay: Int
    
    enum CodingKeys: String, CodingKey {
        case date = "last_updated"
        case temp = "temp_c"
        case condition
        case feelsLikeTemp = "feelslike_c"
        case windKpH = "wind_kph"
        case humidity
        case pressureMB = "pressure_mb"
        case isDay = "is_day"
    }
}

struct HourForecastDTO: Decodable {
    let time: String
    let temp: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case time
        case temp = "temp_c"
        case condition
    }
}

struct LocationDTO: Decodable {
    let localtime: String
}

struct ConditionDTO: Decodable {
    let text: String
    let icon: String
}

struct DayDTO: Decodable {
    let dayTemp: Double
    let nightTemp: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case dayTemp = "maxtemp_c"
        case nightTemp = "mintemp_c"
        case condition
    }
}

extension Forecast {
    init(dto: WeatherResponse) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        self.localDate = hourFormatter.date(from: dto.location.localtime) ?? Date()
        
        self.current = CurrentWeather(
            date: hourFormatter.date(from: dto.current.date) ?? Date(timeIntervalSinceNow: 0),
            temperature: Int(dto.current.temp.rounded()),
            icon: dto.current.condition.icon,
            description: dto.current.condition.text,
            feelLikeTemp: Int(dto.current.feelsLikeTemp.rounded()),
            windSpeed: Int((dto.current.windKpH / 3.6).rounded()),
            humidity: dto.current.humidity,
            pressure: Int((dto.current.pressureMB / 1.333).rounded()),
            isDay: (dto.current.isDay != 0)
        )
        
        self.hourForecast = dto.forecast.forecastday.flatMap { dayDTO in
            dayDTO.hour.compactMap { hourDTO in
                guard let date = hourFormatter.date(from: hourDTO.time) else { return nil }
                
                return HourForecast(
                    date: date,
                    temperature: hourDTO.temp,
                    icon: hourDTO.condition.icon
                )
            }
        }
        
        self.weeklyForecast = dto.forecast.forecastday.compactMap { dayDTO in
            guard let date = dayFormatter.date(from: dayDTO.date) else { return nil }
            
            return DayForecast(
                date: date,
                dayTemp: dayDTO.day.dayTemp,
                nightTemp: dayDTO.day.nightTemp,
                icon: dayDTO.day.condition.icon
            )
        }
    }
}
