//
//  ViewController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 06/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit

struct User: Codable {
    let username: String
    let realName: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = APIRequest(method: .post, path: "/user/create")
        let json: [String: String] = ["username": "Test", "realName": "Test"]
        request.body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let networkManager = NetworkManager()
        networkManager.doRequest(request) { (response: APIResult<User>) in
            switch response {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error.localizedDescription);
            }
        }
    }

}

