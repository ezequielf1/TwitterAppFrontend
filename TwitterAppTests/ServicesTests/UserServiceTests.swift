//
//  UserServiceTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 17/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp

class UserServiceTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private let mockUser = User(username: "Mock username", realName: "Mock realName")
    private var userService: UserService?
    private let networkManagerMock = NetworkManagerMock()

    override func setUpWithError() throws {
        userService = UserServiceImplementation(networkManager: networkManagerMock)
    }

    func testWhenGetTweetsSuccessfullyThenReturnTweets() {
        givenSuccessTweetsResult()
        userService?
            .getTweetsOf(username: mockUser.username)
            .subscribe(onSuccess: { tweets in
                XCTAssertEqual(2, tweets.count, "The response should has the same count of the mock tweets result")
        }, onError: { error in
                XCTFail("Error was not expected: \(error)")
        }).disposed(by: disposeBag)
    }
    
    func testWhenUpdateUserSuccessfullyThenReturnNoContentResponse() {
        givenNoContentResult()
        userService?
            .updateUser(user: mockUser)
            .subscribe(onError: { error in
                XCTFail("Error was not expected: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func testWhenPostTweetSuccessfullyThenReturnNoContentResponse() {
        givenNoContentResult()
        userService?
            .postTweet(username: mockUser.username, tweet: "Mock tweet")
            .subscribe(onError: { error in
                XCTFail("Error was not expected: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func testWhenGetFollowingsSuccessfullyThenReturnFollowings() {
        givenSuccessFollowingsResult()
        userService?
            .getFollowingsOf(username: mockUser.username)
            .subscribe(onSuccess: { followings in
                XCTAssertEqual(2, followings.count, "The response should has the same count of the mock followings result")
            }, onError: { error in
                XCTFail("Error was not expected: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func testWhenGetFollowingsFailureThenReturnError() {
        givenFailureResult()
        userService?
            .getFollowingsOf(username: mockUser.username)
            .subscribe(onSuccess: { _ in
                XCTFail("Success was not expected")
            }, onError: { error in
                XCTAssert(error is RequestFailureError)
            }).disposed(by: disposeBag)
    }
    
    func testWhenPostTweetFailureThenReturnError() {
        givenFailureResult()
        userService?
            .postTweet(username: mockUser.username, tweet: "Mock tweet")
            .subscribe(onSuccess: { _ in
                XCTFail("Success was not expected")
            }, onError: { error in
                XCTAssert(error is RequestFailureError)
            }).disposed(by: disposeBag)
    }
    
    func testWhenUpdateUserFailureThenReturnError() {
        givenFailureResult()
        userService?
            .updateUser(user: mockUser)
            .subscribe(onSuccess: { _ in
                XCTFail("Success was not expected")
            }, onError: { error in
                XCTAssert(error is RequestFailureError)
            }).disposed(by: disposeBag)
    }
    
    func testWhenGetTweetsFailureThenReturnError() {
        givenFailureResult()
        userService?
            .getTweetsOf(username: mockUser.username)
            .subscribe(onSuccess: { _ in
                XCTFail("Success was not expected")
            }, onError: { error in
                XCTAssert(error is RequestFailureError)
            }).disposed(by: disposeBag)
    }
    
    private func givenNoContentResult() {
        networkManagerMock.desiredResult = .success(nil)
    }
    
    private func givenSuccessFollowingsResult() {
        let mockFollowingsResult = ["Following 1", "Following 2"]
        networkManagerMock.desiredResult = .success(mockFollowingsResult)
    }
    
    private func givenSuccessTweetsResult() {
        let mockTweetsResult = ["Mock tweet 1", "Mock tweet 2"]
        networkManagerMock.desiredResult = .success(mockTweetsResult)
    }
    
    private func givenFailureResult() {
        networkManagerMock.desiredResult = .failure(RequestFailureError())
    }
}
