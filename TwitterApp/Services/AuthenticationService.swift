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
    private let networkManager = NetworkManager()
}

// MARK: - Authentication
extension AuthenticationService: Authentication {
    func authenticate(username: String, realName: String) -> Single<User> {
        return Single<User>.create { single in
            let request = self.createRequestForCreateUser(username: username, realName: realName)
            self.networkManager.doRequest(request) { (result: APIResult<User>) in
                switch result {
                case .success(let user):
                    single(.success(user))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - Private Methods
private extension AuthenticationService {
    func createRequestForCreateUser(username: String, realName: String) -> APIRequest {
        let apiRequest = APIRequest(endpointItem: .createUser)
        let json: [String: String] = ["username": username, "realName": realName]
        apiRequest.body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return apiRequest
    }
}
