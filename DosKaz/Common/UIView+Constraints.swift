//
//  UIView+Constraints.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

// TODO: Add to Shared
// This is the improvement over autolayout wrapper
// Example
// label.addConstraintsProgrammatically
//  .pin(my: .leading, andOf: view)
//	.pin(my: .top, andOf: view, plus: 200)



public extension UIView {
	
	var addConstraintsProgrammatically: UViewWrapper {
		translatesAutoresizingMaskIntoConstraints = false
		return UViewWrapper(view: self)
	}
}

public struct UViewWrapper {
	let view: UIView
	
	private func activate(this constraint : Constraint) -> Self {
		constraint(self.view).isActive = true
		return self
	}
}
	
extension UViewWrapper {
	
	/// Describes relation between Y anchors of two views
	/// Example: 'pin(my: .top, to: .bottom, of: view, plus: 40)'
	@discardableResult
	func pin(
		my yEdge: YEdge,
		to viewsYEdge : YEdge,
		of view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return activate(this: make(my: yEdge, .equal, to: viewsYEdge, of: view, plus: c))
	}
	
	/// Describes relation between Y anchors of two views
	/// Example: 'pin(my: .top, andOf: view, plus: 16)'
	@discardableResult
	func pin(
		my yEdge: YEdge,
		andOf view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return pin(my: yEdge, to: yEdge, of: view, plus: c)
	}
	
	
	/// Describes relation between X anchors of two views
	/// Example: 'pin(my: .leading, to: .trailing, of: view, plus: 40)'
	@discardableResult
	func pin(
		my xEdge: XEdge,
		to viewsXEdge : XEdge,
		of view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return activate(this:  make(my: xEdge, .equal, to: viewsXEdge, of: view, plus: c))
	}
	
	/// Describes relation between X anchors of two views
	/// Example: 'pin(my: .leading, andOf: view, plus: 16)'
	@discardableResult
	func pin(
		my xEdge: XEdge,
		andOf view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return pin(my: xEdge, to: xEdge, of: view, plus: c)
	}
	
}
