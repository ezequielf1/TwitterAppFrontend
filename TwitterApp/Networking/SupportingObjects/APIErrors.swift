//
//  APIErrors.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

struct InvalidURLError: NetworkError {
    var message = "Invalid URL"
}

struct RequestFailureError: NetworkError {
    var message = "Request failed"
}

struct DecodingError: NetworkError {
    var message = "Decoding error"
}

struct UnknownError: NetworkError {
    var message = "Unknown error"
}

struct InternalServerError: NetworkError {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}

