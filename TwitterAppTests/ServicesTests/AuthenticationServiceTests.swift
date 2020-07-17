//
//  AuthenticationServiceTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 17/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp


class AuthenticationServiceTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private let mockUser = User(username: "Mock username", realName: "Mock realName")
    private let networkManagerMock = NetworkManagerMock()
    private var authenticationService: AuthenticationService?

    override func setUpWithError() throws {
        authenticationService = AuthenticationService(networkManager: networkManagerMock)
    }

    
    func testWhenCreateUserSuccessfullyThenReturnSuccessWithThatUser() {
        givenSuccessResult()
        authenticationService?
            .authenticate(username: mockUser.username, realName: mockUser.realName)
            .subscribe(onSuccess: { [weak self] user in
                XCTAssert(user.username == self?.mockUser.username)
        }) { error in
                XCTFail("Error was not expected: \(error)")
        }.disposed(by: disposeBag)
    }
    
    func testWhenCreateUserFailureThenReturnError() {
        givenFailureResult()
        authenticationService?
            .authenticate(username: mockUser.username, realName: mockUser.realName)
            .subscribe(onSuccess: { _ in
                XCTFail("Success was not expected")
        }) { error in
                XCTAssert(error is RequestFailureError)
        }.disposed(by: disposeBag)
    }
    
    private func givenSuccessResult() {
        networkManagerMock.desiredResult = .success(mockUser)
    }
    
    private func givenFailureResult() {
        networkManagerMock.desiredResult = .failure(RequestFailureError())
    }
}
