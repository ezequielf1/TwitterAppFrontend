//
//  MockAPIRequest.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation
@testable import TwitterApp

final class MockInvalidURLAPIRequest: NetworkRequest {
    var baseURL: URL? = nil
    var path = ""
    var httpMethod: HTTPMethod = .get
}
