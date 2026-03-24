//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Олег Зуев on 02.03.2026.
//

import Foundation

/* Зачем подписал под AnyObjec
    Это нужно что бы удалять координатор по ссылке в методе ремув, мог бы подписат под Equatable, но тогда бы пришлось прописывать по какаим полям сравнивать экзмепляры
 */
 
protocol Coordinator: AnyObject {
    func start()
    var childCoordinators: [Coordinator] { get set }
}


extension Coordinator {
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}


