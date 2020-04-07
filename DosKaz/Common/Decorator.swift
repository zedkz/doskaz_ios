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
}

extension UIView: DecoratorCompatible {}


typealias Decoration<T> = (T) -> Void

struct Decorator<T> {
	let object: T
	func apply(_ decorations: Decoration<T>...) -> Void {
		decorations.forEach({ $0(object) })
	}
}

struct Style {
	
	static var languageButton: Decoration<UIButton> {
		return { (view: UIButton) in
			view.setTitleColor(.white, for: .normal)
			view.backgroundColor = .systemGreen
			view.layer.borderWidth = 1
			view.layer.borderColor = UIColor.white.cgColor
		}
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


extension UIButton {
	func decorate(with decorations: Decoration<UIButton>...) {
		decorations.forEach({ decorator.apply($0) })
	}
}
