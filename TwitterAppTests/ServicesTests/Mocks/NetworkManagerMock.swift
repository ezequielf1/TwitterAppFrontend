//
//  NetworkManagerMock.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 17/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation
@testable import TwitterApp

final class NetworkManagerMock: NetworkManager {
    typealias Desired<Z> = APIResult<Z>
    var desiredResult: Desired<Any>?
    
    func doRequest<T: Codable>(_ request: APIRequest, _ completion: @escaping APIClientCompletion<T>) {
        guard let desiredResult = desiredResult else { return }
        switch desiredResult {
        case .success(let response):
            completion(.success(response as? T))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
