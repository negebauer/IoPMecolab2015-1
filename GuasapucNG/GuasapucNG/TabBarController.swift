//
//  TabBarController.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 13-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var chatManager = ChatManager()
    
    override func viewDidLoad() {
        self.delegate = self
        self.selectedIndex = 0
        (((self.selectedViewController as! UINavigationController).viewControllers[0]) as! ViewController).chatManager = chatManager
        self.selectedIndex = 1
        (((self.selectedViewController as! UINavigationController).viewControllers[0]) as! ViewControllerGroups).chatManager = chatManager
        self.selectedIndex = 2
        (((self.selectedViewController as! UINavigationController).viewControllers[0]) as! MapView).chatManager = chatManager
        self.selectedIndex = 0
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {

    }
}