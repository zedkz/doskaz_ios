//
//  UIView+Constraints.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

// TODO: Add to Shared
// This is the improvement over autolayout wrapper
// Example
// label.addConstraintsProgrammatically
//  .pin(my: .leading, andOf: view)
//	.pin(my: .top, andOf: view, plus: 200)


import UIKit

public enum Dimensions {
	case width
	case height
	
	var keyPath: KeyPath<UIView, NSLayoutDimension> {
		switch self {
		case .width:
			return \UIView.widthAnchor
		case .height:
			return \UIView.heightAnchor
		}
	}
	
}

public enum YEdge {
	case top
	case bottom
	case verticalCenter
	case firstBaseline
	case lastBaseline
	
	var keyPath: KeyPath<UIView, NSLayoutYAxisAnchor> {
		switch self {
		case .top:
			return \UIView.topAnchor
		case .bottom:
			return \UIView.bottomAnchor
		case .verticalCenter:
			return \UIView.centerYAnchor
		case .firstBaseline:
			return \UIView.firstBaselineAnchor
		case .lastBaseline:
			return \UIView.lastBaselineAnchor
		}
	}
	
}

public enum XEdge {
	case leading
	case trailing
	case horizontalCenter
	
	var keyPath: KeyPath<UIView, NSLayoutXAxisAnchor> {
		switch self {
		case .leading:
			return \UIView.leadingAnchor
		case .trailing:
			return \UIView.trailingAnchor
		case .horizontalCenter:
			return \UIView.centerXAnchor
		}
	}
	
}

public enum SafeYEdge {
	case top
	case bottom
	case verticalCenter
	
	var keyPath: KeyPath<UIView, NSLayoutYAxisAnchor> {
		switch self {
		case .top:
			return \UIView.safeLayoutGuide.topAnchor
		case .bottom:
			return \UIView.safeLayoutGuide.bottomAnchor
		case .verticalCenter:
			return \UIView.safeLayoutGuide.centerYAnchor
		}
	}
	
}

public enum SafeXEdge {
	case leading
	case trailing
	case horizontalCenter
	
	var keyPath: KeyPath<UIView, NSLayoutXAxisAnchor> {
		switch self {
		case .leading:
			return \UIView.safeLayoutGuide.leadingAnchor
		case .trailing:
			return \UIView.safeLayoutGuide.trailingAnchor
		case .horizontalCenter:
			return \UIView.safeLayoutGuide.centerXAnchor
		}
	}
	
}

extension UIView {
	var addConstraintsProgrammatically: Anchor {
		translatesAutoresizingMaskIntoConstraints = false
		return Anchor(view: self)
	}
	
	var safeLayoutGuide: UILayoutGuide {
		if #available(iOS 11, *) {
			return safeAreaLayoutGuide
		} else {
			return layoutMarginsGuide
		}
	}
}

public class Anchor {
	
	let callingView: UIView
	
	var constraint: NSLayoutConstraint?
	
	init(view: UIView) {
		self.callingView = view
	}
	
}

extension Anchor {
	
	/// Common method for all other constraint makers with X and Y
	private func constrain<Anchor, Axis>(
		anchor myAnchor: KeyPath<UIView, Anchor>,
		with relation: NSLayoutConstraint.Relation = .equal,
		to otherViewsAnchor: KeyPath<UIView, Anchor>,
		of view: UIView,
		plus c: CGFloat
	) -> Self where Anchor: NSLayoutAnchor<Axis> {
		
		let anchor = callingView[keyPath: myAnchor]
		let otherAnchor = view[keyPath: otherViewsAnchor]
		
		var constraint: NSLayoutConstraint?
		
		switch relation {
		case .equal:
			constraint = anchor.constraint(equalTo: otherAnchor, constant: c)
		case .greaterThanOrEqual:
			constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: c)
		case .lessThanOrEqual:
			constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: c)
		@unknown default:
			break
		}
		
		constraint?.isActive = true
		self.constraint = constraint
		
		return self
	}
	
	private func constrain<LayoutDimension>(
		dimension myDimension: KeyPath<UIView, LayoutDimension>,
		with relation: NSLayoutConstraint.Relation,
		to otherDimension: KeyPath<UIView, LayoutDimension>,
		of view: UIView,
		times x: CGFloat,
		plus c: CGFloat
	) -> Self where  LayoutDimension: NSLayoutDimension {
		
		let dimension = callingView[keyPath: myDimension]
		let otherDimension = view[keyPath: otherDimension]
		
		var constraint: NSLayoutConstraint?
		
		switch relation {
		case .equal:
			constraint = dimension.constraint(equalTo: otherDimension, multiplier: x, constant: c)
		case .greaterThanOrEqual:
			constraint = dimension.constraint(greaterThanOrEqualTo: otherDimension, multiplier: x, constant: c)
		case .lessThanOrEqual:
			constraint = dimension.constraint(lessThanOrEqualTo: otherDimension, multiplier: x, constant: c)
		@unknown default:
			break
		}
		
		constraint?.isActive = true
		self.constraint = constraint
		
		return self
	}
	
}

/// XEdge
extension Anchor {
	
	/// Describes relation between X anchors of two views
	/// Example: 'set(my: .leading, .equal, to: .trailing, of: view, plus: 30)'
	@discardableResult
	public func set(
		my xEdge: XEdge,
		_ relation: NSLayoutConstraint.Relation,
		to viewsXEdge : XEdge,
		of view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: xEdge.keyPath, with: relation, to: viewsXEdge.keyPath, of: view, plus: c)
	}
	
	/// Describes relation between X anchors of two views
	/// Example: 'pin(my: .leading, to: .trailing, of: view, plus: 40)'
	@discardableResult
	public func pin(
		my xEdge: XEdge,
		to viewsXEdge : XEdge,
		of view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: xEdge.keyPath, with: .equal, to: viewsXEdge.keyPath, of: view, plus: c)
	}
	
	/// Describes relation between X anchors of two views
	/// Example: 'pin(my: .leading, andOf: view, plus: 16)'
	@discardableResult
	public func pin(
		my xEdge: XEdge,
		andOf view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: xEdge.keyPath, with: .equal, to: xEdge.keyPath, of: view, plus: c)
	}
	
	/// Pin edge to super view
	/// Example: '.pinEdgeToSuper(my: .leading)'
	@discardableResult
	public func pinEdgeToSupers(
		_ xEdge: XEdge,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: xEdge.keyPath, with: .equal, to: xEdge.keyPath, of: callingView.superview!, plus: c)
	}
	
	/// Pin edge to super view
	/// Example: '.pinEdgeToSupersSafe(: .leading)'
	@discardableResult
	public func pinEdgeToSupersSafe(
		_ xEdge: SafeXEdge,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: xEdge.keyPath, with: .equal, to: xEdge.keyPath, of: callingView.superview!, plus: c)
	}
	
}

/// YEdge
extension Anchor {
	
	/// Describes relation between Y anchors of two views
	/// Example: 'make(my: .bottom, .equal, to: .top, of: view, plus: 40)'
	@discardableResult
	public func set(
		my yEdge: YEdge,
		_ relation: NSLayoutConstraint.Relation,
		to viewsYEdge : YEdge,
		of view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: yEdge.keyPath, with: relation, to: viewsYEdge.keyPath, of: view, plus: c)
	}
	
	/// Describes relation between Y anchors of two views
	/// Example: 'pin(my: .top, to: .bottom, of: view, plus: 40)'
	@discardableResult
	public func pin(
		my yEdge: YEdge,
		to viewsYEdge : YEdge,
		of view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: yEdge.keyPath, with: .equal, to: viewsYEdge.keyPath, of: view, plus: c)
	}
	
	/// Describes relation between Y anchors of two views
	/// Example: 'pin(my: .top, andOf: view, plus: 16)'
	@discardableResult
	public func pin(
		my yEdge: YEdge,
		andOf view: UIView,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: yEdge.keyPath, with: .equal, to: yEdge.keyPath, of: view, plus: c)
	}
	
	/// Pin edge to super view
	/// Example: '.pinEdgeToSuper(my: .leading)'
	@discardableResult
	public func pinEdgeToSupers(
		_ yEdge: YEdge,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: yEdge.keyPath, with: .equal, to: yEdge.keyPath, of: callingView.superview!, plus: c)
	}
	
	/// Pin edge to super view
	/// Example: '.pinEdgeToSupersSafe(: .leading)'
	@discardableResult
	public func pinEdgeToSupersSafe(
		_ yEdge: SafeYEdge,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(anchor: yEdge.keyPath, with: .equal, to: yEdge.keyPath, of: callingView.superview!, plus: c)
	}
	
}

/// Dimension
extension Anchor {
	
	/// Describes relation between dimension of two views
	/// Example: 'make(my: .height, .greaterThanOrEqual, to: .width, of: view, times: 2, plus: 3)'
	@discardableResult
	public func set(
		my dimension: Dimensions,
		_ relation: NSLayoutConstraint.Relation ,
		to viewsDimension : Dimensions,
		of view: UIView,
		times x: CGFloat = 1,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(dimension: dimension.keyPath, with: relation, to: viewsDimension.keyPath, of: view, times: x, plus: c)
	}
	
	/// Describes constraint that will be equal to greater or less than a constant
	/// Examples: 'set(my: .height, to: 22)'
	/// 'set(my: .height, .greaterThanOrEqual, to: 23)'
	/// 'set(my: .height, .lessThanOrEqual, to: 23)'
	@discardableResult
	public func set(
		my dimension: Dimensions,
		_ relation: NSLayoutConstraint.Relation = .equal,
		to constant: CGFloat
	) -> Self {
		
		let anchor = callingView[keyPath: dimension.keyPath]
		
		switch relation {
		case .equal:
			constraint = anchor.constraint(equalToConstant: constant)
		case .greaterThanOrEqual:
			constraint = anchor.constraint(greaterThanOrEqualToConstant: constant)
		case .lessThanOrEqual:
			constraint = anchor.constraint(lessThanOrEqualToConstant: constant)
		@unknown default:
			break
		}
		
		constraint?.isActive = true
		
		return self
		
	}
	
	/// Describes relation between dimension of two views
	/// Example: 'match(my: .height, and: .height, of: view, times: 2, plus: 3)'
	@discardableResult
	public func equate(
		my dimension: Dimensions,
		and viewsDimension : Dimensions,
		of view: UIView,
		times x: CGFloat = 1,
		plus c: CGFloat = 0
	) -> Self {
		return constrain(dimension: dimension.keyPath, with: .equal, to: viewsDimension.keyPath, of: view, times: x, plus: c)
	}
	
}

/// Super view
extension Anchor {
	
	/// Pin view to its superview safeArea
	@discardableResult
	public func pinToSuperSafeArea(
		inset i: UIEdgeInsets = UIEdgeInsets(all: 0)
	) -> Self {
		let superview = callingView.superview!
		return constrain(anchor: YEdge.top.keyPath, to: \.safeLayoutGuide.topAnchor, of: superview, plus: i.top)
			.constrain(anchor: YEdge.bottom.keyPath, to: \.safeLayoutGuide.bottomAnchor, of: superview, plus: -i.bottom)
			.constrain(anchor: XEdge.leading.keyPath, to: \.safeLayoutGuide.leadingAnchor, of: superview, plus: i.left)
			.constrain(anchor: XEdge.trailing.keyPath, to: \.safeLayoutGuide.trailingAnchor, of: superview, plus: -i.right)
	}
	
	/// Pin view to its superview
	@discardableResult
	public func pinToSuper(
		inset i: UIEdgeInsets = UIEdgeInsets(all: 0)
	) -> Self {
		return pinEdgeToSupers(.leading, plus: i.left)
			.pinEdgeToSupers(.trailing, plus: -i.right)
			.pinEdgeToSupers(.top, plus: i.top)
			.pinEdgeToSupers(.bottom, plus: -i.bottom)
	}
	
}

