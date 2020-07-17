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
    var networkManager: NetworkManagerImplementation?
    var createUserRequest: APIRequest?
    let mockSession = URLSessionMock()
    
    override func setUp() {
        networkManager = NetworkManagerImplementation.shared
        networkManager?.session = mockSession
        createUserRequest = APIRequest(request: CreateUserRequest())
    }
    
    func testSuccessfullResponse() {
        let mockUser = createMockUserResponse()
        let data = createJson(with: mockUser)
        mockSession.data = data
        mockSession.response = createMockURLResponseWith(statusCode: 200)
        
        let expect = expectation(description: "")
        var response: APIResult<User>?
        
        networkManager?.doRequest(createUserRequest!) { (result: APIResult<User>) in
            response = result
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2)
        if case .success(let user) = response {
            XCTAssertEqual(user?.username, mockUser.username)
        } else {
            XCTFail("Error was not expected")
        }
    }
    
    func testDecodingFailureResponse() {
        let expect = expectation(description: "Decoding failure")
        var response: APIResult<User>?
        mockSession.response = createMockURLResponseWith(statusCode: 200)

        networkManager?.doRequest(createUserRequest!) { (result: APIResult<User>) in
            response = result
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2)
        if case .failure(let error) = response {
            XCTAssert(error is DecodingError)
        } else {
            XCTFail("Success was not expected")
        }
    }
    
    func testRequestFailureResponse() {
        let expect = expectation(description: "Request failure")
        var response: APIResult<User>?
        
        networkManager?.doRequest(createUserRequest!) { (result: APIResult<User>) in
            response = result
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2)
        if case .failure(let error) = response {
            XCTAssert(error is RequestFailureError)
        } else {
            XCTFail("Success was not expected")
        }
    }
    
    func testInvalidURLFailureResponse() {
        let expect = expectation(description: "Invalid URL failure")
        var response: APIResult<User>?
        let request = APIRequest(request: MockInvalidURLAPIRequest())
        
        networkManager?.doRequest(request, { (result: APIResult<User>) in
            response = result
            expect.fulfill()
        })
        wait(for: [expect], timeout: 0.5)
        if case .failure(let error) = response {
            XCTAssert(error is InvalidURLError)
        } else {
            XCTFail("Success was not expected")
        }
    }
    
    func testNoContentSuccessResponse() {
        let expect = expectation(description: "No content success response")
        let request = APIRequest(request: MockPutAPIRequest())
        var result: APIResult<String?>?
        mockSession.response = createMockURLResponseWith(statusCode: 204)
        
        networkManager?.doRequest(request, { (response: APIResult<String?>) in
            result = response
            expect.fulfill()
        })
        wait(for: [expect], timeout: 0.5)
        if case .success(let response) = result {
            XCTAssertNil(response ?? nil)
        } else {
            XCTFail("Error was not expected")
        }
    }
    
    func testInternalServerErrorFailureResponse() {
        let json: [String: String] = ["message": "Mock internal server error"]
        
        let expect = expectation(description: "Internal server error")
        let request = APIRequest(request: MockPutAPIRequest())
        var result: APIResult<String?>?
        mockSession.response = createMockURLResponseWith(statusCode: 500)
        mockSession.data = json.convertToJson()
        
        networkManager?.doRequest(request, { (response: APIResult<String?>) in
            result = response
            expect.fulfill()
        })
        wait(for: [expect], timeout: 0.5)
        if case .failure(let error) = result {
            XCTAssert(error is InternalServerError)
        } else {
            XCTFail("Success was not expected")
        }
    }
    
    private func createMockUserResponse() -> User {
        return User(username: "Test", realName: "Test")
    }
    
    private func createJson(with user: User) -> Data? {
        let parameters: [String: String] = ["username": user.username, "realName": user.realName]
        return parameters.convertToJson()
    }
    
    private func createMockURLResponseWith(statusCode: Int) -> URLResponse? {
        HTTPURLResponse(url: URL(fileURLWithPath: "url"), statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}
