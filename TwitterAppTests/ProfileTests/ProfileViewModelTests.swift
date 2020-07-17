//
//  ProfileViewModelTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
import RxSwift
@testable import TwitterApp

class ProfileViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private var viewModel: ProfileViewModel?
    private let mockUserService = UserServiceMock()

    override func setUpWithError() throws {
        viewModel = ProfileViewModel(userService: mockUserService)
        LoggedUser.shared.username = "MockUserLogged"
    }
    
    func testWhenUserChangeRealNameThenSaveButtonChangeItsStateToEnabled() {
        givenUserWith(realName: "Initial mock real name")
        whenThatUserChangeHisRealName(to: "Mock new real name")
        thenIsSaveActiveChangeItsState(to: true)
    }
    
    func testWhenUserDoesNotChangeRealNameThenSaveButtonIsDisabled() {
        givenUserWith(realName: "Initial mock real name")
        thenIsSaveActiveChangeItsState(to: false)
    }
    
    func testWhenRealnameIsSuccessfullyUpdatedThenDidUpdateNameChange() {
        whenAUserUpdateHisRealnameSuccesfully()
        thenDidUpdateNameIsUpdated()
    }
    
    func testWhenRealnameHasFailureInUpdateThenDidFailUpdateNameChange() {
        whenAUserUpdateHisRealnameFailure()
        thenDidFailUpdateNameIsUpdated()
    }
    
    private func whenAUserUpdateHisRealnameFailure() {
        mockUserService.updateUserResult = .failure(APIErrorMock.mockError)
    }
    
    private func thenDidFailUpdateNameIsUpdated() {
        let expectDidFailUpdateNameChange = expectation(description: "DidFailUpdateName should change")
        viewModel?.didFailUpdateName.subscribe(onNext: { _ in
            expectDidFailUpdateNameChange.fulfill()
        })
        .disposed(by: disposeBag)
        viewModel?.saveButtonTapped()
        wait(for: [expectDidFailUpdateNameChange], timeout: 0.1)
    }
    
    private func whenAUserUpdateHisRealnameSuccesfully() {
        mockUserService.updateUserResult = .success(())
    }
    
    private func thenDidUpdateNameIsUpdated() {
        let expectDidUpdateNameChange = expectation(description: "DidUpdateName should change")
        viewModel?.didUpdateName.subscribe(onNext: {
            expectDidUpdateNameChange.fulfill()
        })
        .disposed(by: disposeBag)
        
        viewModel?.saveButtonTapped()
        wait(for: [expectDidUpdateNameChange], timeout: 0.1)
    }
    
    private func givenUserWith(realName: String) {
        LoggedUser.shared.realName = "MockInitialRealName"
    }
    
    private func whenThatUserChangeHisRealName(to realName: String) {
        viewModel?.realName.onNext(realName)
    }
    
    private func thenIsSaveActiveChangeItsState(to value: Bool) {
        let expectIsSaveActiveChange = expectation(description: "isSaveActive observable change")
        viewModel?.isSaveActive.subscribe(onNext: { state in
            if state == value { expectIsSaveActiveChange.fulfill() }
        })
        .disposed(by: disposeBag)
        wait(for: [expectIsSaveActiveChange], timeout: 0.1)
    }
}
