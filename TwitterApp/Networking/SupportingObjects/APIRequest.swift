//
//  APIRequest.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 08/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

final class APIRequest {
    let endpointItem: EndpointItem
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(endpointItem: EndpointItem) {
        self.endpointItem = endpointItem
    }
}
