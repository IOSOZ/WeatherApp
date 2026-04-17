//
//  ImageCacheService.swift
//  WeatherApp
//
//  Created by Олег Зуев on 09.04.2026.
//

import Foundation
import UIKit

final class ImageCacheService {
    // MARK: - Private Properties
    private let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Load Image 
    func loadImage(
        from path: String,
        completion: @escaping (UIImage?) -> Void) {
            
            let fullPath = path.hasPrefix("http") ? path : "https:\(path)"
            
            if let cached = cache.object(forKey: fullPath as NSString) {
                completion(cached)
                return
            }
            
            guard let url = URL(string: fullPath) else { return }
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard
                    let data,
                    let image = UIImage(data: data)
                else { return }
                self?.cache.setObject(image, forKey: fullPath as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
}
