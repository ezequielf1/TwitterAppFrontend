//
//  APIRequests.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

struct CreateUserRequest: NetworkRequest {
    var path = "/user/create"
    var httpMethod: HTTPMethod = .post
}

struct UpdateUserRequest: NetworkRequest {
    var path = "/user/update"
    var httpMethod: HTTPMethod = .put
}

struct AskFollowingsRequest: NetworkRequest {
    var path = "/user/askfollow"
    var httpMethod: HTTPMethod = .get
}

struct GetTweetsRequest: NetworkRequest {
    var path = "/user/getTweets"
    var httpMethod: HTTPMethod = .get
}

struct PostTweetRequest: NetworkRequest {
    var path = "/user/postTweet"
    var httpMethod: HTTPMethod = .patch
}

struct FollowRequest: NetworkRequest {
    var path = "/user/follow"
    var httpMethod: HTTPMethod = .patch
}
