//
//  ProfileDrawerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/18/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileDrawerViewController: UIViewController {
	
	// MARK - Beginning
	
	var currentViewController: UIViewController?
	
	override open func loadView() {
		super.loadView()
		view = DrawerView()
	}
	
	var drawerView: DrawerView {
		return view as! DrawerView
	}
	
	weak var delegate: DrawerViewDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		drawerView.panToPosition(drawerView.openFullPosition, animated: true, completion: nil)
	}
	
	// MARK: - Display permanent view controllers
	
	func configureViews(with profileView: ProfileView) {
		drawerView.displayViewFirst(profileView)
		configureTab()
	}
	
	var tabBar: UITabBar!
	
	private func configureTab() {
		let tabBar = UITabBar()
		
		let items = [
			UITabBarItem(title: nil, image: UIImage(named: "object_description"), selectedImage: UIImage(named: "object_description_active")),
			UITabBarItem(title: nil, image: UIImage(named: "object_photo"), selectedImage: UIImage(named: "object_photo_active")),
			UITabBarItem(title: nil, image: UIImage(named: "object_reviews"), selectedImage: UIImage(named: "object_reviews_active")),
			UITabBarItem(title: nil, image: UIImage(named: "object_video"), selectedImage: UIImage(named: "object_video_active")),
			UITabBarItem(title: nil, image: UIImage(named: "object_history"), selectedImage: UIImage(named: "object_history_active"))
		]
		
		items.enumerated().forEach { args in
			args.element.tag = args.offset
			args.element.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
		}
		
		tabBar.setItems(items, animated: false)
		tabBar.delegate = self
		tabBar.selectedItem = items.first
		drawerView.displayViewInContentView(tabBar)
		self.tabBar(tabBar, didSelect: items.first!)
		self.tabBar = tabBar
	}
	
	
	// MARK: - Display view controllers
	
	/// Shows a view controller in the drawer view's content view.
	///
	/// - Parameter viewController: The view controller to show.
	func show(viewController: UIViewController) {
		guard viewController != currentViewController else { return }
		
		// If a VC's view was already added to the drawer, remove it.
		if let currentViewController = currentViewController {
			currentViewController.view.removeFromSuperview()
			currentViewController.removeFromParent()
		}
		
		// Add the VC's view to the drawer.
		currentViewController = viewController
		addChild(currentViewController!)
		drawerView.displayViewInContentView(currentViewController!.view)
	}
	
}

extension ProfileDrawerViewController: UITabBarDelegate {
	
	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		switch item.tag {
		case 0:
			let vc = VenueDescriptionBuilder().assembleModule()
			show(viewController: vc)
		case 1:
			show(viewController: GreetingModuleConfigurator().assembleModule())
		default:
			break
		}
	}
	
}

