//
//  APIRequest.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 08/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

class APIRequest {
    let request: NetworkRequest
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(request: NetworkRequest) {
        self.request = request
    }
}
