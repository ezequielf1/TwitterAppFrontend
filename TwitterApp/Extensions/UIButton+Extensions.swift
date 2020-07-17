//
//  UIButton+Extensions.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 17/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
