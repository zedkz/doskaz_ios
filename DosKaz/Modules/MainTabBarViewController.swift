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
		
		tabBar.tintColor = UIColor(named: "SelectedTabbarTintColor")
		tabBar.barTintColor = UIColor(red:1, green:1, blue:1, alpha:1)
		tabBar.unselectedItemTintColor = UIColor(named: "UnselectedTabbarTintColor")
		
		let map = MapModuleConfigurator().assembleTab()
		let instruction = InstructionViewController().tab(with: "tab_map", title: "Instruction")
		viewControllers = [map,instruction]
		
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
