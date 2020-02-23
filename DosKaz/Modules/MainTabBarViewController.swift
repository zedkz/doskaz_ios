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
		
		let map = MapModuleConfigurator().assembleTab()
		viewControllers = [map]
		
	}

	
}


extension UIViewController {
	func tab(with imageName: String, title: String) -> UINavigationController {
		let navigationController = UINavigationController(rootViewController: self)
		let image = UIImage(named: imageName)
		let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
		navigationController.tabBarItem = tabBarItem
		return navigationController
	}
}
