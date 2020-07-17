//
//  TableView+Extensions.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit

extension UITableView {
    // MARK: - Register
    func registerNib<T>(forType type: T.Type) where T: UITableViewCell {
        let identifier = String(describing: type)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}
