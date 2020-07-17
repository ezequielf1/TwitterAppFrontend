//
//  RequestBuilderTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
@testable import TwitterApp

class RequestBuilderTests: XCTestCase {
    private let mockUser = User(username: "Mock username", realName: "Mock realname")
    private let requestBuilder = RequestBuilder()
    
    func testWhenBuildCreateUserRequestThenBodyShouldContainUserProperties() {
        let expectedBody = ["username": mockUser.username, "realName": mockUser.realName].convertToJson()
        let request = requestBuilder.buildCreateUserRequest(username: mockUser.username, realName: mockUser.realName)
        
        checkEqualityBetweenData(expected: expectedBody, actual: request.body)
        XCTAssert(request.request is CreateUserRequest)
    }
    
    func testWhenBuildUpdateUserRequestThenReturnUpdateUserRequestWithBodyWithUserProperties() {
        let expectedBody = ["username": mockUser.username, "realName": mockUser.realName].convertToJson()
        let request = requestBuilder.buildUpdateUserRequest(user: mockUser)
        
        checkEqualityBetweenData(expected: expectedBody, actual: request.body)
        XCTAssert(request.request is UpdateUserRequest)
    }
    
    func testWhenBuildGetFollowingsRequestThenReturnGetFollowingsRequestWithUsernameAsQuery() {
        let expectedQuery = URLQueryItem(name: "username", value: mockUser.username)
        let request = requestBuilder.buildGetFollowingsRequest(username: mockUser.username)
        
        XCTAssert(expectedQuery == request.queryItems?.first)
        XCTAssert(request.request is AskFollowingsRequest)
    }
    
    func testWhenBuildGetTweetsRequesThenReturnGetTweetsRequestWithUsernameAsQuery() {
        let expectedQuery = URLQueryItem(name: "username", value: mockUser.username)
        let request = requestBuilder.buildGetTweetsRequest(username: mockUser.username)
        
        XCTAssert(expectedQuery == request.queryItems?.first)
        XCTAssert(request.request is GetTweetsRequest)
    }
    
    func testWhenBuildPostTweetRequestThenReturnPostTweetRequestWithDataInBody() {
        let mockTweet = "Mock tweet"
        let expectedBody = ["username": mockUser.username, "tweet": mockTweet].convertToJson()
        let request = requestBuilder.buildPostTweetRequest(username: mockUser.username, tweet: mockTweet)
        
        checkEqualityBetweenData(expected: expectedBody, actual: request.body)
        XCTAssertTrue(request.request is PostTweetRequest)
    }
    
    func testWhenBuildFollowRequestThenReturnFollowRequestWithDataInBody() {
        let followerUsername = "First user"
        let followedUsername = "Second user"
        let expectedBody = ["followerUsername": followerUsername, "followedUsername": followedUsername]
            .convertToJson()
        let request = requestBuilder.buildFollowRequest(followerUsername: followerUsername, followedUsername: followedUsername)
        
        checkEqualityBetweenData(expected: expectedBody, actual: request.body)
        XCTAssertTrue(request.request is FollowRequest)
    }
    
    private func checkEqualityBetweenData(expected: Data?, actual: Data?) {
        XCTAssertTrue(expected == actual)
    }
}
