//
//  SignInViewModel.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class SignInViewModel {
    // MARK: - Public Properties
    let username = BehaviorSubject(value: "")
    let signInIsActive: Observable<Bool>
    let didTapSignIn = PublishSubject<User>()
    
    init() {
        signInIsActive = username.asObservable().map { !$0.isEmpty }
    }
    
    func signInButtonTapped() {
        didTapSignIn.onNext((getLoggedUser()))
    }
    
    private func getLoggedUser() -> User {
        return User(username: username.getUnwrappedValue() ?? "", realName: "")
    }
}
