//
//  LabeledTableViewCell.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 16/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit

final class LabeledTableViewCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!
    
    func setup(text: String) {
        label.text = text
    }
}
