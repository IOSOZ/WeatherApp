//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Олег Зуев on 30.03.2026.
//

import Foundation
import CoreLocation
import Combine

struct WeatherViewState {
    var isLoading: Bool = false
    var forecast: Forecast?
    var cityTitle: String = "Москва, Россия"
    var errorMessage: String?
    var citySuggestions: [CitySuggestion] = []
}

protocol WeatherViewModelInput {
    func viewDidLoad()
    func didSelectCity(_ suggestion: CitySuggestion)
}

@MainActor
final class WeatherViewModel: WeatherViewModelInput {
    
    // MARK: - Outputs
    var onBackToAuth: (() -> Void)?
    
    // MARK: - DI
    private let weatherService: WeatherServiceProtocol
    private var locationService: LocationServiceProtocol
    private let citySearchService: CitySearchServiceProtocol
    private let localSessionStore: LocalSessionStoreProtocol
    
    // MARK: - State
    @Published var state = WeatherViewState()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let defaultCoordinates = Coordinates(
        latitude: 59.9390,
        longitude: 30.3158
    )

    // MARK: - Init
    init(
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol,
        citySearchService: CitySearchServiceProtocol,
        localSessionStore: LocalSessionStoreProtocol
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.citySearchService = citySearchService
        self.localSessionStore = localSessionStore
    }
    
    // MARK: - Setup Logic
    func viewDidLoad() {
        bindSearch()
        bindLocationService()
        
        if locationService.isLocationAvilable {
            state.isLoading = true
            locationService.requestCurrentLocation()
        } else {
            loadForecast(for: defaultCoordinates, cityTitle: "Санкт-Петербург, Россия")
            locationService.requestAuthorization()
        }
    }
    
    func didSelectCity(_ suggestion: CitySuggestion) {
        state.citySuggestions = []
        loadForecast(for: suggestion.coordinates, cityTitle: suggestion.title)
    }
    
    func  didEnter(letters: String) {
        if letters.isEmpty { state.citySuggestions = [] }
        searchTextSubject.send(letters)
    }
    
    func didTapLogout() {
        localSessionStore.clearSession()
        onBackToAuth?()
    }
}

private extension WeatherViewModel {
    
    // MARK: - Bind location service
    func bindLocationService() {
        locationService.onLocationReceived = { [weak self] coordinates in
            self?.locationService.reverseGeocode(coordinates: coordinates) { cityTitle in
                self?.loadForecast(for: coordinates, cityTitle: cityTitle ?? "Моя геолокация")
            }
        }
        
        locationService.onLocationError = { error in
            print("Location error:", error)
        }
        
        locationService.onAuthorizationStatusChanged = { status in
            print("Location status:", status.rawValue)
        }
    }
    
    // MARK: - Bind search
    func bindSearch() {
        searchTextSubject
            .debounce(for: .milliseconds(500) , scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] text in
                self?.searchCity(text: text)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Network
private extension WeatherViewModel {
    func loadForecast(for coordinates: Coordinates, cityTitle: String) {
        state.isLoading = true
        state.errorMessage = nil
        
        Task {
            do {
                let forecast = try await weatherService.getForecast(coordinates: coordinates, days: 10)
                state.isLoading = false
                state.forecast = forecast
                state.cityTitle = cityTitle
            } catch {
                print("Get Weather Error: ", error )
            }
        }
    }
    
    func searchCity(text: String) {
        Task {
            do {
                let suggestions = try await citySearchService.searchCities(text: text)
                state.citySuggestions = suggestions
            } catch {
                print("Search Error: ", error )
            }
        }
    }
}
