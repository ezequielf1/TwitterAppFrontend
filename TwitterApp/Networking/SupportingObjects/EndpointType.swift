//
//  EndpointType.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 06/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Alamofire

protocol EndpointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL? { get }
    var encoding: ParameterEncoding { get }
}
