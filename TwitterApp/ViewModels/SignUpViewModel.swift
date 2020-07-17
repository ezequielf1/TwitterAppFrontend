//
//  SignUpViewModel.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class SignUpViewModel {
    // MARK: - Public Properties
    let username = BehaviorSubject(value: "")
    let realName = BehaviorSubject(value: "")
    let isRegistrationActive: Observable<Bool>
    
    let didSignUp = PublishSubject<Void>()
    let didFailSignUp = PublishSubject<Error>()
    let didSignInTapped = PublishSubject<Void>()
    
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    private let authenticationService: Authentication
    private var loggedUser = LoggedUser.shared
    
    init(authenticationService: Authentication) {
        self.authenticationService = authenticationService
        isRegistrationActive = Observable.combineLatest(username, realName).map { !$0.0.isEmpty && !$0.1.isEmpty }
    }
}

// MARK: - Public Methods
extension SignUpViewModel {
    func signUpButtonTapped() {
        authenticationService
            .authenticate(username: username.getUnwrappedValue() ?? "",
                          realName: realName.getUnwrappedValue() ?? "")
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.updateLoggedUser()
                self?.didSignUp.onNext(())
            }, onError: { [weak self] error in
                self?.didFailSignUp.onNext(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func signInButtonTapped() {
        didSignInTapped.onNext(())
    }
}

// MARK: - Private Methods
private extension SignUpViewModel {
    func updateLoggedUser() {
        loggedUser.username = username.getUnwrappedValue()
        loggedUser.realName = realName.getUnwrappedValue()
    }
}
