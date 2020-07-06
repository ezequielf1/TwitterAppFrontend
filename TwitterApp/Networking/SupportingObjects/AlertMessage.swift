//
//  AlertMessage.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 06/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

enum AlertMessage {
    case internalServerError
    case noInternetConnection
    case serverError(String, String)
    case parseError
    case unknownError
    
    var associatedValue: (title: String, message: String) {
        switch self {
        case .internalServerError:
            return (title: "Internal server error", message: "")
        case .noInternetConnection:
            return (title: "No internet connection", message: "")
        case .serverError(let title, let message):
            return (title: title, message: message)
        case .parseError:
            return (title: "Parsing error", message: "")
        case .unknownError:
            return (title: "Unknown error", message: "")
        }
    }
}
