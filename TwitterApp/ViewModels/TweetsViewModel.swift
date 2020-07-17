//
//  TweetsViewModel.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class TweetsViewModel {
    
    let tweets = PublishSubject<[String]>()
    let didFailureRetrievingTweets = PublishSubject<Error>()
    let didFailurePostingTweet = PublishSubject<Error>()
    let isTweetPostActive: Observable<Bool>
    let tweetText = BehaviorSubject(value: "")
    
    private let userService: UserService
    private let disposeBag = DisposeBag()
    private let username: String
    
    init(userService: UserService, username: String) {
        self.userService = userService
        self.username = username
        isTweetPostActive = tweetText.asObservable().map { !$0.isEmpty }
    }
}

// MARK: - Public Methods
extension TweetsViewModel {
    func getTweets() {
        userService.getTweetsOf(username: username)
            .subscribeOn(MainScheduler.instance).subscribe(onSuccess: { [weak self] tweets in
                self?.tweets.onNext(tweets)
            }) { [weak self] error in
                self?.didFailureRetrievingTweets.onNext(error)
        }.disposed(by: disposeBag)
    }
    
    func postTweet() {
        guard let tweet = tweetText.getUnwrappedValue(), !tweet.isEmpty else { return }
        userService.postTweet(username: username, tweet: tweet)
            .subscribe(onSuccess: { [weak self] in
                self?.getTweets()
        }) { [weak self] error in
                self?.didFailurePostingTweet.onNext(error)
        }.disposed(by: disposeBag)
    }
}
