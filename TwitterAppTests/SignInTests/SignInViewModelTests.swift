//
//  SignInViewModelTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp

class SignInViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private let mockUser = User(username: "MockUsername", realName: "MockRealName")
    private var viewModel: SignInViewModel?

    override func setUpWithError() throws {
        viewModel = SignInViewModel()
    }
    
    func testWhenUsernameValueChangedThenButtonStateValidatorIsCalled() {
        viewModel?.username.onNext(mockUser.username)
        let expectSignInActiveIsCalled = expectation(description: "SignInActive observable is called")
        viewModel?.signInIsActive.subscribe(onNext: { state in
            guard state else { return }
            expectSignInActiveIsCalled.fulfill()
        })
        .disposed(by: disposeBag)
        wait(for: [expectSignInActiveIsCalled], timeout: 0.1)
    }

}
