//
//  FollowingsViewModelTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp

class FollowingsViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private var viewModel: FollowingsViewModel?
    private let mockUserService = UserServiceMock()
    
    override func setUpWithError() throws {
        viewModel = FollowingsViewModel(userService: mockUserService, username: "MockLoggedUser")
        LoggedUser.shared.username = "MockUserLogged"
    }
    
    func testWhenAskFollowingsSuccessfulThenUpdateFollowingsObservable() {
        mockUserService.getFollowingsResult = .success(["MockResult1", "MockResult2"])
        
        let expectFollowingsChange = expectation(description: "Followings should change")
        viewModel?.followings.subscribe(onNext: { followings in
            if !followings.isEmpty { expectFollowingsChange.fulfill() }
        })
        .disposed(by: disposeBag)
        viewModel?.getFollowings()
        wait(for: [expectFollowingsChange], timeout: 0.1)
    }
    
    func testWhenAskFollowingsFailureThenDidFailAskFollowingsShouldChange() {
        mockUserService.getFollowingsResult = .failure(APIErrorMock.mockError)
        
        let expectDidFailAskFollowings = expectation(description: "DidFailAskFollowings should change")
        viewModel?.didFailAskingFollowings.subscribe(onNext: { _ in
            expectDidFailAskFollowings.fulfill()
        })
        .disposed(by: disposeBag)
        viewModel?.getFollowings()
        wait(for: [expectDidFailAskFollowings], timeout: 0.1)
    }
    
    func testWhenUserTapOnAFollowingThenDidTapOnFollowingChangeItsValue() {
        let indexTapped = 0
        viewModel?.followings.onNext(["MockResult1", "MockResult2"])
        let expectDidTapOnFollowingChange = expectation(description: "DidTapOnFollowing change")
        viewModel?.didTapOnFollowingUser.subscribe(onNext: { userTapped in
            expectDidTapOnFollowingChange.fulfill()
            XCTAssertEqual(userTapped, self.viewModel?.followings.getUnwrappedValue()?[indexTapped])
        })
        .disposed(by: disposeBag)
        viewModel?.didTapOnFollowingUser(index: indexTapped)
        wait(for: [expectDidTapOnFollowingChange], timeout: 0.1)
    }
}
