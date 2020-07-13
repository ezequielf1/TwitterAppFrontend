//
//  APIError.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 08/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
}
