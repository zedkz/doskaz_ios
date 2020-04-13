//
//  DrawerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
	
	override open func loadView() {
		super.loadView()
		view = DrawerView()
	}
	
	var drawerView: DrawerView {
		return view as! DrawerView
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
