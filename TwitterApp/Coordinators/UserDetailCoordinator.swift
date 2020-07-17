//
//  UserDetailCoordinator.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class UserDetailCoordinator: BaseCoordinator {
    let username: String
    let userService: UserService
    
    init(userService: UserService, username: String) {
        self.userService = userService
        self.username = username
    }
    
    override func start() {
        let userDetailVC: UserDetailViewController = UserDetailViewController.loadFromNib()
        userDetailVC.viewModel = UserDetailViewModel(userService: userService, username: username)
        navigationController.pushViewController(userDetailVC, animated: true)
    }
}
