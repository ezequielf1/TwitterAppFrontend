//
//  URLRequestBuilder.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

final class URLRequestBuilder {
    func buildURLRequest(for request: APIRequest) -> URLRequest? {
        let urlComponents = createURLComponents(request: request)
        guard let url = urlComponents.url?.appendingPathComponent(request.request.path),
            !url.absoluteString.isEmpty else {
            return nil
        }
        return createUrlRequestWithAllComponents(url: url, request: request)
    }
    
    private func createURLComponents(request: APIRequest) -> URLComponents {
        var urlComponents = URLComponents()
        guard let baseURL = request.request.baseURL else {
            return urlComponents
        }
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.port = baseURL.port
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        return urlComponents
    }
    
    private func createUrlRequestWithAllComponents(url: URL, request:  APIRequest) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.request.httpMethod.rawValue
        urlRequest.httpBody = request.body
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        return urlRequest
    }
}

