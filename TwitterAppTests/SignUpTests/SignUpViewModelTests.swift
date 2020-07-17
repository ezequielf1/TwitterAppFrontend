//
//  SignUpViewModelTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp

class SignUpViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private let mockUser = User(username: "MockUsername", realName: "MockRealName")
    private let mockAuthenticationService = AuthenticationServiceMock()
    private var viewModel: SignUpViewModel?

    override func setUpWithError() throws {
        viewModel = SignUpViewModel(authenticationService: mockAuthenticationService)
    }
    
    func testWhenUsernameOrRealnameChangeThenValidationIsCalled() {
        viewModel?.username.onNext(mockUser.username)
        viewModel?.realName.onNext(mockUser.realName)
        
        let expectUpdateContinueButtonState = expectation(description: "isRegistrationActive is called")
        viewModel?.isRegistrationActive.subscribe(onNext: { state in
            guard state else { return }
            expectUpdateContinueButtonState.fulfill()
        })
        .disposed(by: disposeBag)
        wait(for: [expectUpdateContinueButtonState], timeout: 0.1)
    }
    
    func testWhenContinueButtonIsCalledWithValidDataThenDidSignUpChanged() {
        mockAuthenticationService.createUserResult = .success(mockUser)
        
        let expectDidSignUpCalled = expectation(description: "didSignUp observable was called")
        viewModel?.didSignUp.subscribe(onNext: {
            expectDidSignUpCalled.fulfill()
        })
        .disposed(by: disposeBag)
        viewModel?.signUpButtonTapped()
        wait(for: [expectDidSignUpCalled], timeout: 0.1)
    }
    
    func testWhenContinueButtonIsCalledWithInvalidDataThenDidSignUpFailureChanged() {
        mockAuthenticationService.createUserResult = .failure(APIErrorMock.mockError)
        
        let expectDidSignUpFailureCalled = expectation(description: "didSignUpFailure observable was called")
        viewModel?.didFailSignUp.subscribe(onNext: { _ in
            expectDidSignUpFailureCalled.fulfill()
        })
        .disposed(by: disposeBag)
        viewModel?.signUpButtonTapped()
        wait(for: [expectDidSignUpFailureCalled], timeout: 0.1)
    }
    
    func testWhenSignInButtonTappedIsCalledThenNavigateToSignInScreen() {
        let expectDidTapSignInCalled = expectation(description: "didSignInTapped observable was called")
        viewModel?.didSignInTapped.subscribe(onNext: {
            expectDidTapSignInCalled.fulfill()
        })
        .disposed(by: disposeBag)
        viewModel?.signInButtonTapped()
        wait(for: [expectDidTapSignInCalled], timeout: 0.1)
    }
}
