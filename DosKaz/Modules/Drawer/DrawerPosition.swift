//
//  DrawerPosition.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

/// Represents a position that the drawer can be open to.
open class DrawerPosition: Equatable {
	
	public static func == (lhs: DrawerPosition, rhs: DrawerPosition) -> Bool {
		return lhs.panDistance == rhs.panDistance && lhs.canShowKeyboard == rhs.canShowKeyboard
	}
	
	/// The closure that calculates the position's content height.
	var contentHeightClosure: (() -> (CGFloat))?
	
	/// The visible content height of the position.
	var contentHeight: CGFloat {
		guard let contentHeightClosure = contentHeightClosure else { return 0 }
		return contentHeightClosure()
	}
	
	/// The pan distance that the drawer needs to be moved up the screen (negative view coordinate
	/// direction) to snap to this position. This is the negative of the content height.
	var panDistance: CGFloat {
		return -contentHeight
	}
	
	/// Whether or not a drawer position allows showing the keyboard.
	let canShowKeyboard: Bool
	
	/// Designated initializer.
	///
	/// - Parameters:
	///   - canShowKeyboard: Whether or not a drawer position allows showing the keyboard.
	///   - contentHeightClosure: The closure that calculates the position's visible content height.
	public init(canShowKeyboard: Bool, contentHeightClosure: (() -> (CGFloat))? = nil) {
		self.canShowKeyboard = canShowKeyboard
		self.contentHeightClosure = contentHeightClosure
	}
	
}

extension  UIView {
	/// Returns the safe area insets if available, otherwise zero.
	var safeAreaInsetsOrZero: UIEdgeInsets {
		var insets: UIEdgeInsets = .zero
		if #available(iOS 11.0, *) {
			insets = safeAreaInsets
		}
		return insets
	}
}

extension ClosedRange {
	/// Clamps a value between a lower and upper bound.
	///
	/// - Parameter value: The value to clamp.
	/// - Returns: The resulting value.
	func clamp(_ value : Bound) -> Bound {
		return lowerBound > value ? lowerBound : ((upperBound < value) ? upperBound : value)
	}
}
