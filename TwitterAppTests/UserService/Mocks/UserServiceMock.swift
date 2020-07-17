//
//  UserServiceMock.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift
@testable import TwitterApp

final class UserServiceMock: UserService {
    var updateUserResult: Result<Void, Error>?
    var getFollowingsResult: Result<[String], Error>?
    var getTweetsResult: Result<[String], Error>?
    var postTweetResult: Result<Void, Error>?
    var postTweetCalled = false
    var getTweetsCalled = false
    
    func getFollowingsOf(username: String) -> Single<[String]> {
        return Single<[String]>.create { single in
            switch self.getFollowingsResult {
            case .success(let followings): single(.success(followings))
            case .failure(let error): single(.error(error))
            case .none: single(.error(APIErrorMock.mockError))
            }
            return Disposables.create()
        }
    }
    
    func getTweetsOf(username: String) -> Single<[String]> {
        getTweetsCalled = true
        return Single<[String]>.create { single in
            switch self.getTweetsResult {
            case .success(let tweets): single(.success(tweets))
            case .failure(let error): single(.error(error))
            case .none: single(.error(APIErrorMock.mockError))
            }
            return Disposables.create()
        }
    }
    
    func updateUser(user: User) -> Single<Void> {
        return Single<Void>.create { single in
            switch self.updateUserResult {
            case .success: single(.success(()))
            case .failure(let error): single(.error(error))
            case .none: single(.error(APIErrorMock.mockError))
            }
            return Disposables.create()
        }
    }
    
    func postTweet(username: String, tweet: String) -> Single<Void> {
        postTweetCalled = true
        return Single<Void>.create { single in
            switch self.postTweetResult {
            case .success: single(.success(()))
            case .failure(let error): single(.error(error))
            case .none: single(.error(APIErrorMock.mockError))
            }
            return Disposables.create()
        }
    }
}
