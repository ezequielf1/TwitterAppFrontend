//
//  RequestBuilder.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

final class RequestBuilder {
    func buildGetFollowingsRequest(username: String) -> APIRequest {
        let request = APIRequest(request: AskFollowingsRequest())
        request.queryItems = [URLQueryItem(name: "username", value: username)]
        return request
    }
    
    func buildUpdateUserRequest(user: User) -> APIRequest {
        let request = APIRequest(request: UpdateUserRequest())
        let parameters: [String: String] = ["username": user.username, "realName": user.realName]
        request.body = parameters.convertToJson()
        return request
    }
    
    func buildCreateUserRequest(username: String, realName: String) -> APIRequest {
        let request = APIRequest(request: CreateUserRequest())
        let parameters: [String: String] = ["username": username, "realName": realName]
        request.body = parameters.convertToJson()
        return request
    }
    
    func buildGetTweetsRequest(username: String) -> APIRequest {
        let request = APIRequest(request: GetTweetsRequest())
        request.queryItems = [URLQueryItem(name: "username", value: username)]
        return request
    }
    
    func buildPostTweetRequest(username: String, tweet: String) -> APIRequest {
        let request = APIRequest(request: PostTweetRequest())
        let parameters: [String: String] = ["username": username, "tweet": tweet]
        request.body = parameters.convertToJson()
        return request
    }
}
