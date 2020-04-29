//
//  DrawerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
	
	// MARK: - Modes of drawer vc. 1) Venue sheet and Profile vc
	
	func render(venue: DoskazVenue) {
		currentVenueViewController?.output.show(venue)
 		setPositionToHalf()
	}
	
	var currentVenueViewController: VenueViewController?

	var currentViewController: UIViewController?
	
	override open func loadView() {
		super.loadView()
		view = DrawerView()
	}
	
	var drawerView: DrawerView {
		return view as! DrawerView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		drawerView.decorateContent(with: Style.topCornersRounded)
		
		configureTopView()
		configureTab()
	}
	
	// MARK: - Display permanent view controllers
	
	private func configureTopView() {
		let venueViewController = VenueBuilder().assembleModule()
		addChild(venueViewController)
		drawerView.displayViewFirst(venueViewController.view)
		venueViewController.didMove(toParent: self)
		currentVenueViewController = venueViewController
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
	
	// MARK: - Drawer Position
	
	/// Sets the drawer position to full.
	///
	/// - Parameter: animated: Whether or not to animate. Default is true.
	func setPositionToFull(animated: Bool = true) {
		setPosition(drawerView.openFullPosition, animated: animated)
	}

	/// Sets the drawer position to half.
	///
	/// - Parameters:
	///   - animated: Whether or not to animate. Default is true.
	///   - completion: Called when setting the position to half completes, if it can open to half.
	///                 Otherwise called immediately.
	func setPositionToHalf(animated: Bool = true, completion: (() -> Void)? = nil) {
		setPosition(drawerView.openHalfPosition, animated: animated, completion: completion)
	}
	
	/// Sets the drawer position to peeking.
	///
	/// - Parameters:
	///   - animated: Whether or not to animate. Default is true.
	///   - completion: Called when setting the position to peeking completes, if it can open to
	///                 peeking. Otherwise called immediately.
	func setPositionToPeeking(animated: Bool = true, completion: (() -> Void)? = nil) {
		setPosition(drawerView.peekingPosition, animated: animated, completion: completion)
	}
		
	// MARK: - Private
	
	/// Sets the drawer position.
	///
	/// - Parameters:
	///   - position: The position.
	///   - animated: Whether or not to animate the change.
	///   - completion: Called when setting the position completes.
	private func setPosition(_ position: DrawerPosition,
													 animated: Bool = true,
													 completion: (() -> Void)? = nil) {
		drawerView.panToPosition(position, animated: animated, completion: completion)
	}
	
}

extension DrawerViewController: UITabBarDelegate {
	
	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		switch item.tag {
		case 0:
			show(viewController: VenueDescriptionBuilder().assembleModule())
		case 1:
			show(viewController: GreetingModuleConfigurator().assembleModule())
		default:
			break
		}
	}
	
}
