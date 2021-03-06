//
//  DrawerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class DrawerViewController: UIViewController {
	
	// MARK: - Venue sheet methods
	
	func reload() {
		guard let id = currentDoskazVenue?.id else { return }
		
		let onSuccess = { [weak self] (doskazVenue: DoskazVenue) -> Void in
			guard let self = self else { return }
			
			var venue = doskazVenue
			venue.id = id
			
			if let selected = self.tabBar.selectedItem {
				self.currentDoskazVenue = venue
				self.tabBar(self.tabBar, didSelect: selected)
			}
			
		}
		
		let onFailure = { (error: Error) in
			print("Object reload failed")
		}
		
		let r = APIGetObject(onSuccess: onSuccess, onFailure: onFailure, id: id)
		r.dispatch()
		
	}
	
	func render(venue: DoskazVenue) {
		currentDoskazVenue = venue
		if let items = tabBar.items, let first = items.first {
			tabBar(tabBar, didSelect: first)
			tabBar.selectedItem = first
		}
		currentVenueViewController?.output.show(venue)
 		setPositionToHalf()
	}
	
	var currentDoskazVenue: DoskazVenue!
	
	var currentVenueViewController: VenueViewController?
	
	// MARK - Beginning

	var currentViewController: UIViewController?
	
	override open func loadView() {
		view = DrawerView(delegate: self)
	}
	
	var drawerView: DrawerView {
		return view as! DrawerView
	}
	
	weak var delegate: DrawerViewDelegate?
	
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
			UITabBarItem(title: nil, image: UIImage(named: "object_history"), selectedImage: UIImage(named: "object_history_active")),
			UITabBarItem(title: nil, image: UIImage(named: "object_video"), selectedImage: UIImage(named: "object_video_active")),
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
	
	//MARK: - Tabs
	
	let photos = VenuePhotosBuilder().assembleModule()
	
	let videos = VenueVideoViewContoller()
}

extension DrawerViewController: UITabBarDelegate {
	
	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		switch item.tag {
		case 0:
			let vc = VenueDescriptionBuilder().assembleModule()
			if let venue = currentDoskazVenue {
				vc.output.render(doskazVenue: venue, onReview: Command { [weak self] in
					self?.reload()
				})
			}
			show(viewController: vc)
		case 1:
			if let venuePhotos = currentDoskazVenue?.photos, let id = currentDoskazVenue.id {
				photos.output.initView(with: venuePhotos, objectId: id)
			}
			show(viewController: photos)
		case 2:
			let reviews = VenueFeedbackViewController()
			guard let venueReviews = currentDoskazVenue?.reviews else { return }
			guard let id = currentDoskazVenue?.id else { return }
			reviews.initWith(venueReviews)
			reviews.initWith(objectId: id, onClose: Command { [weak self] in
				self?.reload()
			})
			show(viewController: reviews)
		case 3:
			let historyViewContoller = VenueHistoryViewController()
			let venueHistorys = currentDoskazVenue?.history ?? []
			historyViewContoller.initWith(venueHistorys)
			show(viewController: historyViewContoller)
		case 4:
			if let venueVideos = currentDoskazVenue?.videos {
				videos.initWith(with: venueVideos)
			}
			show(viewController: videos)
		default:
			break
		}
	}
	
}

extension DrawerViewController: DrawerViewDelegate {
	func drawerView(_ drawerView: DrawerView, didChangePosition position: DrawerPosition) {
		delegate?.drawerView(drawerView, didChangePosition: position)
	}
	
	func drawerViewIsPanning(_ drawerView: DrawerView) {
		delegate?.drawerViewIsPanning(drawerView)
	}
}
