//
//  NetworkManager.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 06/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    // MARK: - Private Properties
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
    
    private static var sharedNetworkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    // MARK: - Initializer
    private init() {}
}

// MARK: - Public Methods
extension NetworkManager {
    func doRequest<T: Codable>(type: EndpointType,
                               params: Parameters? = nil,
                               completionHandler: @escaping (T?, _ error: AlertMessage?) -> Void) {
        guard let url = type.url else {
            completionHandler(nil, .unknownError)
            return
        }
        sessionManager
            .request(url, method: type.httpMethod,
                               encoding: type.encoding,
                               headers: type.headers)
            .validate()
            .responseJSON { data in
            switch data.result {
            case .success:
                if let jsonData = data.data {
                    self.parseSuccessRequest(data: jsonData, completionHandler: completionHandler)
                }
            case .failure(let error):
                completionHandler(nil, self.getError(error, data: data))
            }
        }
    }
}


// MARK: - Private Methods
private extension NetworkManager {
    func parseSuccessRequest<T: Codable>(data: Data,
                                         completionHandler: @escaping (T?, _ error: AlertMessage?) -> Void) {
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(T.self, from: data) else {
            completionHandler(nil, .parseError)
            return
        }
        completionHandler(result, nil)
    }
    
    func getError(_ error: Error, data: DataResponse<Any>) -> AlertMessage {
        return isInternetConnectionError(error) ? .noInternetConnection : getError(from: data)
    }
    
    func isInternetConnectionError(_ error: Error) -> Bool {
        guard let error = error as? URLError else {
            return false
        }
        return error.code == .notConnectedToInternet ||
            error.code == .timedOut ||
            error.code == .networkConnectionLost
    }
    
    func getError(from data: DataResponse<Any>) -> AlertMessage {
        switch data.response?.statusCode ?? 0 {
        case 500...599:
            return .internalServerError
        default:
            return parseApiError(data: data.data)
        }
    }
    
    func parseApiError(data: Data?) -> AlertMessage {
        let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(APIError.self, from: jsonData) {
            return .serverError(error.message, "")
        }
        return .parseError
    }
}
