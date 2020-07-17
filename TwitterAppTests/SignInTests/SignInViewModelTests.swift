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
        givenAFirstUsername()
        whenThatUsernameChange()
        thenSignInActiveIsUpdated()
    }
    
    func testWhenSignInIsTappedWithValidDataThenNavigateToUserMainScreen() {
        let expectDidTapSignInIsCalled = expectation(description: "DidTapSignIn observable is called")
        viewModel?.didTapSignIn.subscribe(onNext: {
            expectDidTapSignInIsCalled.fulfill()
        })
        .disposed(by: disposeBag)
        viewModel?.signInButtonTapped()
        wait(for: [expectDidTapSignInIsCalled], timeout: 0.1)
    }
    
    private func givenAFirstUsername() {
        viewModel?.username.onNext("First Username")
    }
    
    private func whenThatUsernameChange() {
        viewModel?.username.onNext("Second username")
    }
    
    private func thenSignInActiveIsUpdated() {
        let expectSignInActiveIsCalled = expectation(description: "SignInActive observable is called")
        viewModel?.signInIsActive.subscribe(onNext: { state in
            guard state else { return }
            expectSignInActiveIsCalled.fulfill()
        })
        .disposed(by: disposeBag)
        wait(for: [expectSignInActiveIsCalled], timeout: 0.1)
    }

}
