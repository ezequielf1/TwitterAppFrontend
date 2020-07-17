//
//  UserDetailViewModelTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 17/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp

class UserDetailViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private let userService = UserServiceMock()
    private var viewModel: UserDetailViewModel?
    
    override func setUpWithError() throws {
        viewModel = UserDetailViewModel(userService: userService, username: "Mock username")
    }

    func testWhenTapOnFollowingsThenReturnFollowingsSuccesfully() {
        givenGetFollowingsSuccessResult()
        let expect = expectation(description: "CurrentDataToShow should be updated with the followings result")
        viewModel?.currentDataToShow.subscribe(onNext: { data in
                expect.fulfill()
                XCTAssertEqual(2, data.count, "Data length should be the same as the one retrieved by the backend")
        }).disposed(by: disposeBag)
        viewModel?.didTapOnFollowingsTab()
        wait(for: [expect], timeout: 0.1)
    }
    
    func testWhenTapOnTweetsThenReturnTweetsSuccessfully() {
        givenGetTweetsSuccessResult()
        let expect = expectation(description: "CurrentDataToShow should be updated with the tweets result")
        viewModel?.currentDataToShow.subscribe(onNext: { data in
            expect.fulfill()
            XCTAssertEqual(2, data.count, "Data length should be the same as the one retrieved by the backend")
        }).disposed(by: disposeBag)
        viewModel?.didTapOnTweetsTab()
        wait(for: [expect], timeout: 0.1)
    }
    
    func testWhenTapOnFollowingsThenReturnGetFollowingsFailure() {
        givenGetTweetsFailureResult()
        let expect = expectation(description: "DidFailureRetrievingFollowings should be updated")
        viewModel?.didFailureRetrievingFollowings
            .subscribe(onNext: { error in
                expect.fulfill()
            }).disposed(by: disposeBag)
        viewModel?.didTapOnFollowingsTab()
        wait(for: [expect], timeout: 0.1)
    }
    
    func testWhenTapOnTweetsThenReturnTweetsFailure() {
        givenGetTweetsFailureResult()
        let expect = expectation(description: "DidFailureRetrievingTweets should be updated")
        viewModel?.didFailureRetrievingTweets
            .subscribe(onNext: { error in
                expect.fulfill()
            }).disposed(by: disposeBag)
        viewModel?.didTapOnTweetsTab()
        wait(for: [expect], timeout: 0.1)
    }
    
    private func givenGetTweetsFailureResult() {
        userService.getTweetsResult = .failure(APIErrorMock.mockError)
    }
    
    private func givenGetTweetsSuccessResult() {
        userService.getTweetsResult = .success(["Tweet 1", "Tweet 2"])
    }
    
    private func givenGetFollowingsSuccessResult() {
        userService.getFollowingsResult = .success(["Mock following 1", "Mock following 2"])
    }
}
