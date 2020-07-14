//
//  User.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

struct User: Codable {
    let username: String
    let realName: String
    let followings: [String]?
    let followers: [String]?
    let tweets: [String]?
    
    init(username: String,
         realName: String,
         followings: [String]? = nil,
         followers: [String]? = nil,
         tweets: [String]? = nil) {
        self.username = username
        self.realName = realName
        self.followings = followings
        self.followers = followers
        self.tweets = tweets
    }
}
