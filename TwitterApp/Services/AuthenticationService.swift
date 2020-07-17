//
//  AuthenticationService.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import RxSwift

final class AuthenticationService {
    // MARK: - Private Properties
    private let networkManager: NetworkManager
    private let requestBuilder: RequestBuilder
    
    init(networkManager: NetworkManager = NetworkManagerImplementation.shared,
         requestBuilder: RequestBuilder = .init()) {
        self.networkManager = networkManager
        self.requestBuilder = requestBuilder
    }
}

// MARK: - Authentication
extension AuthenticationService: Authentication {
    func authenticate(username: String, realName: String) -> Single<User> {
        return Single<User>.create { single in
            let request = self.requestBuilder.buildCreateUserRequest(username: username, realName: realName)
            self.networkManager.doRequest(request) { (result: APIResult<User>) in
                switch result {
                case .success(let user):
                    if let user = user {
                        single(.success(user))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
