//
//  NetworkError.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

protocol NetworkError: Error, Codable {
    var title: String { get set }
    var message: String { get set }
}

extension NetworkError {
    var title: String { get { "Error" } set {} }
}
