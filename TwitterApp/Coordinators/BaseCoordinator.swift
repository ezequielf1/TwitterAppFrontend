//
//  BaseCoordinator.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator {
    var navigationController = UINavigationController() {
        didSet {
            navigationController.navigationBar.backgroundColor = .gray
        }
    }
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    func start() {
        fatalError("Start methods must be implemented")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func showAlert(with error: Error, viewController: Alertable) {
        if let error = error as? NetworkError {
            viewController.showAlertWith(title: error.title, message: error.message)
        }
    }
}
