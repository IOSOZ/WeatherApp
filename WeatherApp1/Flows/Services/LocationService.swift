//
//  LocationService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.04.2026.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestAuthorization()
    func requestCurrentLocation()
    func reverseGeocode(coordinates: Coordinates, completion: @escaping (String?) -> Void)
    
    var onLocationReceived: ((Coordinates) -> Void)? { get set }
    var onLocationError: ((Error) -> Void)? { get set }
    var onAuthorizationStatusChanged: ((CLAuthorizationStatus) -> Void)? { get set }
}

enum LocationServiceError: Error {
    case accessDenied
    case restricted
    case notDetermined
    case unableToFindLocation
}

final class LocationService: NSObject, LocationServiceProtocol {
    
    var onLocationReceived: ((Coordinates) -> Void)?
    var onLocationError: ((any Error) -> Void)?
    var onAuthorizationStatusChanged: ((CLAuthorizationStatus) -> Void)?
    
    var authorizationStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    private let manager = CLLocationManager()
    
    func requestAuthorization() {
        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        
        case .restricted:
            onLocationError?(LocationServiceError.restricted)
        
        case .denied:
            onLocationError?(LocationServiceError.accessDenied)
       
        case .authorizedAlways, .authorizedWhenInUse:
            onAuthorizationStatusChanged?(manager.authorizationStatus)
        
        @unknown default:
            break
        }
    }
    
    func requestCurrentLocation() {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()

        case .notDetermined:
            onLocationError?(LocationServiceError.notDetermined)
            
        case .denied:
            onLocationError?(LocationServiceError.accessDenied)
            
        case .restricted:
            onLocationError?(LocationServiceError.restricted)
            
        @unknown default:
            break
        }
    }
    
    func reverseGeocode(coordinates: Coordinates, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ru_RU")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            let city = placemark.locality ?? placemark.administrativeArea ?? "Неизвестно"
            let country = placemark.country ?? ""
            completion("\(city), \(country)")

        }
            
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        onAuthorizationStatusChanged?(status)
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
            
        case .denied:
            onLocationError?(LocationServiceError.accessDenied)
            
        case .restricted:
            onLocationError?(LocationServiceError.restricted)
            
        case .notDetermined:
            break
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            onLocationError?(LocationServiceError.unableToFindLocation)
            return
        }
        
        let coordinates = Coordinates(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        onLocationReceived?(coordinates)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationError?(error)
    }
}
