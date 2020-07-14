//
//  NetworkManager.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 08/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import Foundation

final class NetworkManager {
    typealias APIClientCompletion<E> = (APIResult<E>) -> Void
    
    var session = URLSession.shared
    private let baseURL = URL(string: "http://localhost:8080")
    private let decoder = JSONDecoder()
    
    
    func doRequest<T: Codable>(_ request: APIRequest, _ completion: @escaping APIClientCompletion<T>) {
        let urlComponents = createURLComponents(request: request)
    
        guard let url = urlComponents.url?.appendingPathComponent(request.endpointItem.path) else {
            completion(.failure(.invalidURL))
            return
        }
        let urlRequest = createUrlRequestWithAllComponents(url: url, request: request)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            if let decodedItem = try? self.decoder.decode(T.self, from: data ?? Data()) {
                completion(.success(decodedItem))
            } else {
                completion(.failure(.decodingFailure))
            }
        }.resume()
    }
    
    private func createURLComponents(request: APIRequest) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL?.scheme
        urlComponents.host = baseURL?.host
        urlComponents.port = baseURL?.port
        urlComponents.path = baseURL?.path ?? ""
        urlComponents.queryItems = request.queryItems
        return urlComponents
    }
    
    private func createUrlRequestWithAllComponents(url: URL, request: APIRequest) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.endpointItem.httpMethod.rawValue
        urlRequest.httpBody = request.body
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        return urlRequest
    }
}
