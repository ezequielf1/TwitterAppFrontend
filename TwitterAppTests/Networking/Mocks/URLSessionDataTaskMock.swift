//
//  URLSessionDataTaskMock.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 14/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

final class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
