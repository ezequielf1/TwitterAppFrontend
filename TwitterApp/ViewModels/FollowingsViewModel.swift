//
//  FollowingsViewModel.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class FollowingsViewModel {
    // MARK: - Public Properties
    let followings = BehaviorSubject<[String]>(value: [])
    let didFailAskingFollowings = PublishSubject<Error>()
    let didTapOnFollowingUser = PublishSubject<String>()
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    private let userService: UserService
    private let username: String
    
    init(userService: UserService, username: String) {
        self.userService = userService
        self.username = username
    }
}

// MARK: - Public Methods
extension FollowingsViewModel {
    func getFollowings() {
        userService.getFollowingsOf(username: username)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] followings in
                self?.followings.onNext(followings)
        }) { [weak self] error in
                self?.didFailAskingFollowings.onNext(error)
        }.disposed(by: disposeBag)
    }
    
    func didTapOnFollowingUser(index: Int) {
        if let userTapped = followings.getUnwrappedValue()?[index] {
            didTapOnFollowingUser.onNext(userTapped)
        }
    }
}
