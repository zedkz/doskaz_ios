//
//  DrawerPanner.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/30/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class DrawerPanner {
	
	// MARK: - Properties
	
	// Whether or not a pan gesture is currently being handled. Decides whether or not to handle a pan
	// gesture in the upward direction, as well as knowing when to pan the drawer or pan to the next
	// position.
	var isHandlingPanGesture = false
	
	// Whether or not a downward pan gesture should be handled. Decides whether or not to handle the
	// gesture. Decided by the scroll view delegate. Only true when the drag starts from a 0 content
	// offset.
	var shouldHandleDownwardPanGesture = false
	
	// Whether or not an upward pan gesture should be handled. Decides whether or not to handle the
	// gesture. Decided by the scroll view delegate. Only true when the drag starts from a 0 content
	// offset.
	var shouldHandleUpwardPanGesture = false
	
	private let allowsPanningUp: Bool
	private weak var drawerView: DrawerView?
	private weak var scrollView: UIScrollView?
	
	// MARK: - Public
	
	/// Designated initializer.
	///
	/// - Parameters:
	///   - drawerViewController: The drawer view controller.
	///   - scrollView: The scroll view.
	///   - allowsPanningUp: Whether or not the drawer panner will pan upward.
	init(drawerView: DrawerView,
			 scrollView: UIScrollView,
			 allowsPanningUp: Bool = false) {
		self.drawerView = drawerView
		self.scrollView = scrollView
		self.allowsPanningUp = allowsPanningUp
	}
	
	/// Forward scroll view delegate calls to this object to decide whether or not to handle the
	/// scroll view pan gesture.
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		if !shouldHandleDownwardPanGesture {
			shouldHandleDownwardPanGesture = scrollView.contentOffset.y == 0
		}
		shouldHandleUpwardPanGesture = allowsPanningUp
	}
	
	/// Forward scroll view delegate calls to this object to decide whether or not to handle the
	/// scroll view pan gesture.
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !isHandlingPanGesture {
			shouldHandleDownwardPanGesture = false
			shouldHandleUpwardPanGesture = false
		}
	}
	
	/// Forward pan gesture recognizer calls to this object to handle the scroll view pan gesture.
	func handlePanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
		guard let drawerView = drawerView, let scrollView = scrollView,
			
			isHandlingPanGesture ||
				
			(panGestureRecognizer.isPanDownward(in: scrollView) &&
			shouldHandleDownwardPanGesture ||
			!panGestureRecognizer.isPanDownward(in: scrollView) &&
			shouldHandleUpwardPanGesture)
			
			else {
				return
		}
		
		switch panGestureRecognizer.state {
		case .began:
			isHandlingPanGesture = true
		case .changed:
			if isHandlingPanGesture {
				drawerView.pan(distance: panGestureRecognizer.translation(in: scrollView).y)
				// Ensure the content offset stays fixed.
				scrollView.contentOffset.y = 0
			}
		case .ended:
			if isHandlingPanGesture {
				drawerView.completePan(withVelocity: panGestureRecognizer.velocity(in: scrollView).y)
			}
			isHandlingPanGesture = false
			shouldHandleDownwardPanGesture = false
		default:
			break
		}
	}
	
}

extension UIPanGestureRecognizer {
	
	/// Whether or not the pan gesture in a view was downward on the screen.
	///
	/// - Parameter view: The view the gesture occured in.
	/// - Returns: Whether or not the pan was downward.
	func isPanDownward(in view: UIView) -> Bool {
		return velocity(in: view).y > 0
	}
	
}
