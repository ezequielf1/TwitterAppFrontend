//
//  NetworkManager.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 08/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

protocol NetworkManager {
    typealias APIClientCompletion<E> = (APIResult<E>) -> Void
    
    func doRequest<T: Codable>(_ request: APIRequest,
                               _ completion: @escaping APIClientCompletion<T>)
}

final class NetworkManagerImplementation: NetworkManager {
    static var shared = NetworkManagerImplementation()
    var session = URLSession.shared
    
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func doRequest<T: Codable>(_ request: APIRequest,
                               _ completion: @escaping APIClientCompletion<T>) {
        guard let urlRequest = URLRequestBuilder().buildURLRequest(for: request) else {
            completion(.failure(InvalidURLError()))
            return
        }
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(RequestFailureError()))
                return
            }
            self.handleResponse(httpResponse: httpResponse, data: data, completion: completion)
        }.resume()
    }
    
    private func handleResponse<T: Codable>(httpResponse: HTTPURLResponse,
                                            data: Data?,
                                            completion: @escaping APIClientCompletion<T>) {
        switch httpResponse.statusCode {
        case 204:
            completion(.success(nil))
        case 500...599:
            let error: InternalServerError? = self.decode(data: data)
            completion(.failure(error ?? DecodingError()))
        default:
            let decodedItem: T? = self.decode(data: data)
            completion(decodedItem != nil ? .success(decodedItem) : .failure(DecodingError()))
        }
    }
    
    private func decode<T: Codable>(data: Data?) -> T? {
        return try? decoder.decode(T.self, from: data ?? Data())
    }
}
