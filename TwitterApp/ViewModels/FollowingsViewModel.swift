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
    let followIsActive: Observable<Bool>
    let usernameToFollow = BehaviorSubject(value: "")
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    private let userService: UserService
    private let username: String
    
    init(userService: UserService, username: String) {
        self.userService = userService
        self.username = username
        followIsActive = usernameToFollow.asObservable().map { !$0.isEmpty }
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
    
    func startFollow() {
        guard let followedUsername = usernameToFollow.getUnwrappedValue() else { return }
        userService.startFollow(followerUsername: username, followedUsername: followedUsername)
            .subscribe(onSuccess: { [weak self] user in
                self?.followings.onNext(user.followings ?? [])
        }) { error in
                print("Should show error")
        }.disposed(by: disposeBag)
    }
    
    func didTapOnFollowingUser(index: Int) {
        if let userTapped = followings.getUnwrappedValue()?[index] {
            didTapOnFollowingUser.onNext(userTapped)
        }
    }
}
