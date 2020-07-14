//
//  AuthenticationServiceMock.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift
@testable import TwitterApp

final class AuthenticationServiceMock: Authentication {
    var createUserResult: Result<User, Error>?
    
    func authenticate(username: String, realName: String) -> Single<User> {
        return Single.create {  single in
            switch self.createUserResult {
            case .success(let user):
                single(.success(user))
            case .failure(let error):
                single(.error(error))
            case .none:
                single(.error(APIErrorMock.mockError))
            }
            return Disposables.create()
        }
    }
}
