//
//  UserDetailViewModel.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class UserDetailViewModel {
    let didTapOnFollowings = PublishSubject<Void>()
    let didTapOnTweets = PublishSubject<Void>()
    let didFailureRetrievingTweets = PublishSubject<Error>()
    let didFailureRetrievingFollowings = PublishSubject<Error>()
    
    let currentDataToShow = PublishSubject<[String]>()
    
    private let userService: UserService
    private let username: String
    private let disposeBag = DisposeBag()
    
    init(userService: UserService, username: String) {
        self.userService = userService
        self.username = username
    }
    
    func didTapOnFollowingsTab() {
        userService.getFollowingsOf(username: username)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] followings in
                self?.currentDataToShow.onNext(followings)
        }) { [weak self] error in
            self?.didFailureRetrievingFollowings.onNext(error)
        }.disposed(by: disposeBag)
    }
    
    func didTapOnTweetsTab() {
        userService.getTweetsOf(username: username)
            .subscribeOn(MainScheduler.instance).subscribe(onSuccess: { [weak self] tweets in
                self?.currentDataToShow.onNext(tweets)
            }) { [weak self] error in
                self?.didFailureRetrievingTweets.onNext(error)
        }.disposed(by: disposeBag)
    }
}
