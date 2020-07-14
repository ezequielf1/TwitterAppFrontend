//
//  NetworkManagerTests.swift
//  TwitterAppTests
//
//  Created by Brian Ezequiel Fritz on 08/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import XCTest
@testable import TwitterApp

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager?
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://localhost:8080/user/create")!
    let apiRequest = APIRequest(endpointItem: .createUser)
    
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        networkManager = NetworkManager()
        networkManager?.session = urlSession
        expectation = expectation(description: "Expectation")
    }
    
    func testCreateUserSuccessfulResponse() {
        let mockUser = createMockUserResponse()
        setMockURLProtocolRequestHandler(with: createJson(with: mockUser))
        
        networkManager?.doRequest(apiRequest, { (result: APIResult<User>) in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.username, mockUser.username)
                XCTAssertEqual(user.realName, mockUser.realName)
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
    }
    
    func testCreateUserParsingFailure() {
        setMockURLProtocolRequestHandler(with: Data())
        
        networkManager?.doRequest(apiRequest, { (result: APIResult<User>) in
            switch result {
            case .success:
                XCTFail("Success response was not expected")
            case .failure(let error):
                XCTAssertEqual(error, APIError.decodingFailure)
            }
            self.expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
    }
    
    private func setMockURLProtocolRequestHandler(with data: Data?) {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    private func createMockUserResponse() -> User {
        return User(username: "Test", realName: "Test")
    }
    
    private func createJson(with user: User) -> Data? {
        let jsonString = """
        {
        "username": "\(user.username)",
        "realName": "\(user.realName)"
        }
        """
        return jsonString.data(using: .utf8)
    }
}
