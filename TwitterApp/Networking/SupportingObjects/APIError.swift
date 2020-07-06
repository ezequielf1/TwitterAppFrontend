//
//  APIError.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 06/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

struct APIError: Codable {
    let message: String
    let key: String?
}
