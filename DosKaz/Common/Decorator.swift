//
//  Decorator.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/8/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

protocol DecoratorCompatible {
	associatedtype CompatibleType
	var decorator: Decorator<CompatibleType> { get }
}

extension DecoratorCompatible {
	var decorator: Decorator<Self> {
		return Decorator(object: self)
	}
	
	func decorate(with decorations: Decoration<Self>...) {
		decorations.forEach({ decorator.apply($0) })
	}
}

extension UIView: DecoratorCompatible {}


typealias Decoration<T> = (T) -> Void

struct Decorator<T> {
	let object: T
	func apply(_ decorations: Decoration<T>...) -> Void {
		decorations.forEach({ $0(object) })
	}
}

protocol Decorable: class {}

extension Decorable {
	static func decoration(closure: @escaping Decoration<Self>) -> Decoration<Self> {
		return closure
	}
}

extension NSObject: Decorable {}

struct Style {
	
	// MARK: - UIView
	
	static func backgroundColor(color: UIColor? = .white) -> Decoration<UIView> {
		return { $0.backgroundColor = color }
	}
	
	static func corneredBorder(radius: CGFloat, color: UIColor?) -> Decoration<UIView> {
		return { (view: UIView) -> Void in
			view.layer.borderWidth = 1
			view.layer.borderColor = color?.cgColor ?? UIColor.systemGray.cgColor
			view.layer.cornerRadius = radius
		}
	}
	
	// MARK: - UIButton

	static func titleColor(color: UIColor? = .black) -> Decoration<UIButton> {
		return { $0.setTitleColor(color, for: .normal) }
	}
	
	static func systemFont(size: CGFloat = 14, weight: UIFont.Weight = .regular) -> Decoration<UIButton> {
		return { view in
			view.titleLabel?.font = .systemFont(ofSize: size, weight: weight)
		}
	}
	
	static let commonButton = UIButton.decoration { (button) in
		button.decorate(with: Style.systemFont(), titleColor())
	}
	
	// MARK: - UILabel
	
	static func systemFont(size: CGFloat = 14, weight: UIFont.Weight = .regular) -> Decoration<UILabel> {
		return { $0.font = .systemFont(ofSize: size, weight: weight) }
	}
	
	static func multiline(with size: CGFloat = 14) -> Decoration<UILabel> {
		return {
			$0.numberOfLines = 0
			$0.font = .systemFont(ofSize: size)
		}
	}
	
	static let topCornersRounded = UIView.decoration { (view) in
		view.backgroundColor = .white
		view.layer.cornerRadius = 15
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
	}
	
	static let languageButton = UIButton.decoration { (view) in
		view.setTitleColor(.white, for: .normal)
		view.setTitleColor(UIColor(named: "LanguageButtonColor")!, for: .highlighted)
		
		view.layer.borderWidth = 1
		view.layer.borderColor = UIColor.white.cgColor
		view.setBackgroundColor(UIColor(named: "LanguageButtonColor")!, for: .normal)
		view.setBackgroundColor(.white, for: UIControl.State.highlighted)
	}
		
	static func corners(rounded: Bool) -> Decoration<UIView> {
		return { [rounded] (view: UIView) -> Void in
			switch rounded {
			case true:
				let mask = CAShapeLayer()
				let size = CGSize(width: 10, height: 10)
				let rect = view.bounds
				let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: size)
				mask.path = path.cgPath
				view.layer.mask = mask
			default:
				view.layer.mask = nil
			}
		}
	}
}


