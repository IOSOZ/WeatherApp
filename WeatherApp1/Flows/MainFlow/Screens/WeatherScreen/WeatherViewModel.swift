//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation
import CoreLocation

struct WeatherViewState {
    var isLoading: Bool = false
    var forecast: Forecast?
    var cityTitle: String = "Москва, Россия"
    var errorMessage: String?
}

protocol WeatherViewModelInput {
    func viewDidLoad()
    func didSelectCity(_ suggestion: CitySuggestion)
}

protocol WeatherViewModelOutput {
    var onStateChange: ((WeatherViewState) -> Void)? { get set }
}

final class WeatherViewModel: WeatherViewModelInput, WeatherViewModelOutput {
    
    var onStateChange: ((WeatherViewState) -> Void)?
    
    private let weatherService: WeatherServiceProtocol
    private var locationService: LocationServiceProtocol
    
    private var state = WeatherViewState() {
        didSet { onStateChange?(state) }
    }
    
    private let defaultCoordinates = Coordinates(
        latitude: 55.7558,
        longitude: 37.6176
    )
    
    init(
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
    }
    
    func viewDidLoad() {
        bindLocationService()
        loadForecast(for: defaultCoordinates, cityTitle: "Москва, Россия")
        locationService.requestAuthorization()
    }
    
    func didSelectCity(_ suggestion: CitySuggestion) {
        loadForecast(for: suggestion.coordinates, cityTitle: suggestion.title)
    }
}

private extension WeatherViewModel {
    func bindLocationService() {
        locationService.onLocationReceived = { [weak self] coordinates in
            self?.loadForecast(for: coordinates, cityTitle: "Моя геолокация")
        }
        
        locationService.onLocationError = { error in
            print("Location error:", error)
        }
        
        locationService.onAuthorizationStatusChanged = { status in
            print("Location status:", status.rawValue)
        }

    }
    
    func loadForecast(for coordinates: Coordinates, cityTitle: String) {
        state.isLoading = true
        state.errorMessage = nil
        
        weatherService.getForecast(coordinates: coordinates, days: 7) { [weak self] result in
            guard let self else { return }
            
            self.state.isLoading = false
            
            switch result {
            case .success(let forecast):
                self.state.forecast = forecast
                self.state.cityTitle = cityTitle
            case .failure(let error):
                self.state.errorMessage = error.localizedDescription
            }
        }
    }
}
