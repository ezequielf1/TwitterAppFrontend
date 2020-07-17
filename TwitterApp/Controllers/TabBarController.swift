//
//  TabBarController.swift
//  TwitterApp
//
//  Created by Brian Ezequiel Fritz on 15/07/2020.
//  Copyright © 2020 Brian Ezequiel Fritz. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController, Storyboarded {
    // MARK: - Private Properties
    private let itemTitles = ["Tweets", "Followings", "Profile"]
    
    func setUp(with viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        configureItems()
    }
}

// MARK: - Private Methods
private extension TabBarController {
    func configureItems() {
        setItemFor(index: 0, image: UIImage(systemName: "doc.text"))
        setItemFor(index: 1, image: UIImage(systemName: "doc.text.fill"))
        setItemFor(index: 2, image: UIImage(systemName: "person.fill"))
    }
    
    func setItemFor(index: Int, image: UIImage?) {
        let item = UITabBarItem()
        item.title = itemTitles[index]
        item.image = image
        viewControllers?[index].tabBarItem = item
    }
}
