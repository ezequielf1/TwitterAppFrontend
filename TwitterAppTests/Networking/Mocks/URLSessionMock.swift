//
//  URLSessionMock.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

final class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var data: Data?
    var error: Error?
    var response: URLResponse?

    override func dataTask(with url: URL,
                           completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let response = self.response
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let response = self.response
        return URLSessionDataTaskMock {
            completionHandler(data,
                              response,
                              error)
        }
    }
}
