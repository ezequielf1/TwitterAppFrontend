//
//  UserService.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

protocol UserService {
    func getFollowingsOf(username: String) -> Single<[String]>
    func updateUser(user: User) -> Single<Void>
    func getTweetsOf(username: String) -> Single<[String]>
    func postTweet(username: String, tweet: String) -> Single<Void>
}
