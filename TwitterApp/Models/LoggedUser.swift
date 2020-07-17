//
//  LoggedUser.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

final class LoggedUser {
    static let shared = LoggedUser()
    var username: String?
    var realName: String?
    
    private init() {}
}
