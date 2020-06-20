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
		let blog = BlogsBuilder().assembleTab()
		let instruction = InstructionViewController().tab(with: "instruction", title: l10n(.instruction))
		
		let profile: UIViewController
		if AppSettings.token == nil {
			profile = AuthBuilder().assembleTab()
		} else {
			profile = ProfileBuilder().assembleTab()
		}
				
		let more = MoreViewController().tab(with: "more", title: l10n(.more))

		viewControllers = [map,blog,instruction,profile, more]
		
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

class UnderConstruction: UIViewController {
	override func viewDidLoad() {
		view.backgroundColor = .black
		navigationItem.title = "Ведутся работы..."
		let label = UILabel()
		label.text = "Ведутся работы..."
		label.decorate { (label) in
			label.font = .systemFont(ofSize: 28, weight: .bold)
			label.textAlignment = .center
			label.numberOfLines = 0
			label.textColor = .white
		}
		view.addSubview(label)
		label.addConstraintsProgrammatically
			.pinToSuper()
		var ai: UIActivityIndicatorView
		if #available(iOS 13.0, *) {
			ai = UIActivityIndicatorView(style: .large)
		} else {
			ai = UIActivityIndicatorView(style: .whiteLarge)
		}
		ai.color = .systemTeal
		view.addSubview(ai)
		ai.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter, plus: -130)
			.pinEdgeToSupers(.horizontalCenter)
		ai.startAnimating()
	}
}
