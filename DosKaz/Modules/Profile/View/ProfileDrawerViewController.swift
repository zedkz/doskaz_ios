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
		view = DrawerView(isInteractive: false)
	}
	
	var drawerView: DrawerView {
		return view as! DrawerView
	}
	
	weak var delegate: DrawerViewDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		drawerView.setDelegate(self)
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
			UITabBarItem(title: nil, image: UIImage(named: "profile_tasks"), selectedImage: UIImage(named: "profile_tasks_active")),
			UITabBarItem(title: nil, image: UIImage(named: "profile_objects"), selectedImage: UIImage(named: "profile_objects_active")),
			UITabBarItem(title: nil, image: UIImage(named: "profile_comments"), selectedImage: UIImage(named: "profile_comments_active")),
			UITabBarItem(title: nil, image: UIImage(named: "profile_tickets"), selectedImage: UIImage(named: "profile_tickets_active")),
			UITabBarItem(title: nil, image: UIImage(named: "profile_achivement"), selectedImage: UIImage(named: "profile_achivement_active"))
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
	
	//MARK: - List of childControllers
	
	let tabFirst = ProfileTasksViewController()
	
	let tabSecond = ProfileObjectsViewController()
	
	let tabThird = ProfileCommentsViewController()
	
	let tabFourth = ProfileComplaintsViewController()
	
	let tabFifth = ProfileAwardsEventsViewController()
	
}

extension ProfileDrawerViewController: UITabBarDelegate, UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		let bounds = scrollView.bounds
		let contentSize = scrollView.contentSize
		
		let inset = scrollView.contentInset
		let y = offset.y + bounds.size.height - inset.bottom
		
		let reload_distance:CGFloat = 10.0
		guard offset.y > 0 else { return }
		if y > (contentSize.height + reload_distance) {
			print("load more rows")
			if let delegate = currentViewController as? UIScrollViewDelegate {
				delegate.scrollViewDidScroll?(scrollView)
			}
		}
	}
	
	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		switch item.tag {
		case 0:
			show(viewController: tabFirst)
		case 1:
			show(viewController: tabSecond)
		case 2:
			show(viewController: tabThird)
		case 3:
			show(viewController: tabFourth)
		case 4:
			show(viewController: tabFifth)
		default:
			break
		}
	}
	
}

