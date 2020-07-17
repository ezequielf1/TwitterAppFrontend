//
//  UserServiceImplementation.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class UserServiceImplementation {
    // MARK: - Private Properties
    private let networkManager: NetworkManager
    private let requestBuilder: RequestBuilder
    
    init(networkManager: NetworkManager = NetworkManagerImplementation.shared,
         requestBuilder: RequestBuilder = .init()) {
        self.networkManager = networkManager
        self.requestBuilder = requestBuilder
    }
}

// MARK: - UserService
extension UserServiceImplementation: UserService {
    func postTweet(username: String, tweet: String) -> Single<Void> {
        return Single<Void>.create { single in
            let request = self.requestBuilder.buildPostTweetRequest(username: username, tweet: tweet)
            self.networkManager.doRequest(request) { (result: APIResult<String?>) in
                switch result {
                case .success: single(.success(()))
                case .failure(let error): single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getTweetsOf(username: String) -> Single<[String]> {
        return Single<[String]>.create { single in
            let request = self.requestBuilder.buildGetTweetsRequest(username: username)
            self.networkManager.doRequest(request) { (result: APIResult<[String]>) in
                switch result {
                case .success(let tweets): single(.success(tweets ?? []))
                case .failure(let error): single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getFollowingsOf(username: String) -> Single<[String]> {
        return Single<[String]>.create { single  in
            let request = self.requestBuilder.buildGetFollowingsRequest(username: username)
            self.networkManager.doRequest(request) { (result: APIResult<[String]>) in
                switch result {
                case .success(let followings):
                    single(.success(followings ?? []))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func updateUser(user: User) -> Single<Void> {
        return Single<Void>.create { single in
            let request = self.requestBuilder.buildUpdateUserRequest(user: user)
            self.networkManager.doRequest(request) { (result: APIResult<String?>) in
                switch result {
                case .success: single(.success(()))
                case .failure(let error): single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func startFollow(followerUsername: String, followedUsername: String) -> Single<User> {
        return Single<User>.create { single in
            let request = self.requestBuilder.buildFollowRequest(followerUsername: followerUsername,
                                                                 followedUsername: followedUsername)
            self.networkManager.doRequest(request) { (result: APIResult<User>) in
                switch result {
                case .success(let user):
                    if let user = user { single(.success(user)) }
                case .failure(let error): single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
