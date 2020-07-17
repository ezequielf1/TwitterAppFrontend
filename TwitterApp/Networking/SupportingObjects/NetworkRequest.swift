//
//  NetworkRequest.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    var path: String { get set }
    var httpMethod: HTTPMethod { get set }
    var baseURL: URL? { get set }
}

extension NetworkRequest {
    var baseURL: URL? {
        get { URL(string: "http://localhost:8080") }
        set {}
    }
}
