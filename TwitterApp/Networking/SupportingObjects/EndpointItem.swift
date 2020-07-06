//
//  EndpointItem.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 06/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Alamofire

enum EndpointItem {
    case songList
    case songsByAlbum
}

extension EndpointItem: EndpointType {
    var baseURL: String {
        guard let path = Bundle.main.path(forResource: "BaseURL", ofType: "plist"),
            let values = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                return ""
        }
        guard
            let value = values["url"] as? String else {
                return ""
        }
        return value
    }
    
    var path: String {
        switch self {
        case .songList: return "search"
        case .songsByAlbum: return "lookup"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .songList, .songsByAlbum: return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .songList, .songsByAlbum: return [:]
        }
    }
    
    var url: URL? {
        switch self {
        default: return URL(string: baseURL)?.appendingPathComponent(path)
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default: return JSONEncoding.default
        }
    }
}
