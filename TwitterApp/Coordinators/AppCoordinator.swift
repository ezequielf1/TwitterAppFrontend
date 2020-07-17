//
//  AppCoordinator.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class AppCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    
    override func start() {
        let coordinator = SignUpCoordinator()
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
