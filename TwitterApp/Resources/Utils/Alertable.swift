//
//  Alertable.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit

protocol Alertable {
    func showAlertWith(title: String, message: String?)
    func actionsForAlert() -> [UIAlertAction]
}

extension Alertable where Self: UIViewController {
    func showAlertWith(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actionsForAlert().forEach { alert.addAction($0) }
        self.present(alert, animated: true, completion: nil)
    }
}
