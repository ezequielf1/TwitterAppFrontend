//
//  TweetsViewModelTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp

class TweetsViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private let mockUserService = UserServiceMock()
    private var viewModel: TweetsViewModel?

    override func setUpWithError() throws {
        viewModel = TweetsViewModel(userService: mockUserService, username: "Mock username")
    }
    
    func testWhenAskTweetsReturnSuccessThenUpdateDidRetrieveTweetsProperty() {
        mockUserService.getTweetsResult = .success(["Mock Tweet 1", "Mock Tweet 2"])
        
        let expectTweetsChange = expectation(description: "Tweets should change")
        viewModel?.tweets
            .subscribe(onNext: { _ in
                expectTweetsChange.fulfill()
            }).disposed(by: disposeBag)
        
        viewModel?.getTweets()
        wait(for: [expectTweetsChange], timeout: 0.1)
    }
    
    func testWhenAskTweetsReturnFailureThenUpdateDidFailureRetrievingTweetsProperty() {
        mockUserService.getTweetsResult = .failure(APIErrorMock.mockError)
        
        let expectDidFailureRetrievingTweets = expectation(description: "DidFailureRetrievinTweets should change")
        viewModel?.didFailureRetrievingTweets
            .subscribe(onNext: { _ in
                expectDidFailureRetrievingTweets.fulfill()
            }).disposed(by: disposeBag)
        
        viewModel?.getTweets()
        wait(for: [expectDidFailureRetrievingTweets], timeout: 0.1)
    }
    
    func testWhenPostTweetSuccessfullyThenGetTweetsMethodShouldBeCalled() {
        mockUserService.postTweetResult = .success(())
        viewModel?.tweetText.onNext("Mock Tweet")
        
        viewModel?.postTweet()
        
        XCTAssertTrue(mockUserService.getTweetsCalled)
    }
    
    func testWhenPostTweetFailureThenDidFailurePostingTweetShouldChange() {
        mockUserService.postTweetResult = .failure(APIErrorMock.mockError)
        viewModel?.tweetText.onNext("Mock Tweet")
        
        let expectFailurePostingTweetChange = expectation(description: "DidFailurePostingTweet should change")
        viewModel?.didFailurePostingTweet
            .subscribe(onNext: { error in
                expectFailurePostingTweetChange.fulfill()
                XCTAssert(error is APIErrorMock)
            }).disposed(by: disposeBag)
        viewModel?.postTweet()
        wait(for: [expectFailurePostingTweetChange], timeout: 0.1)
    }
    
    func testWhenPostTweetWithEmptyTextThenReturn() {
        viewModel?.tweetText.onNext("")
        
        viewModel?.postTweet()
        
        XCTAssertFalse(mockUserService.postTweetCalled)
    }
}
