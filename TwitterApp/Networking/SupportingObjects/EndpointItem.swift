//
//  EndpointItem.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 13/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

enum EndpointItem {
    case createUser
    case updateUser
}

extension EndpointItem {
    var path: String {
        switch self {
        case .createUser: return "/user/create"
        case .updateUser: return "/user/update"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createUser: return .post
        case .updateUser: return .put
        }
    }
}
