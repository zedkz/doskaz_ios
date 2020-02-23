//
//  MainTabBarViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.tintColor = UIColor.systemBlue
		tabBar.barTintColor = UIColor(red:1, green:1, blue:1, alpha:0.53)
		tabBar.unselectedItemTintColor = UIColor(red:0.28, green:0.29, blue:0.4, alpha:1)
		
		let firstTab = UIViewController()
		viewControllers = [firstTab]
		
	}

	
}


protocol Tabbable {
	static var tab: UIViewController { get }
}

extension Tabbable {
	static var tab: UIViewController {
		let mainViewController = UIViewController()
		let navigationController = UINavigationController(rootViewController: mainViewController)
		let image = UIImage(named: "main_tab_icon")
		let tabBarItem = UITabBarItem(title: "Main", image: image, selectedImage: image)
		navigationController.tabBarItem = tabBarItem
		return navigationController
	}
}
