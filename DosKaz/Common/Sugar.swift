//
//  Sugar.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/29/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

/// E.g. let result = evaluate(x > 2, ifTrue: 30, ifFalse: 20)
func evaluate<Result>(_ condition: @autoclosure () -> Bool, ifTrue: Result, ifFalse: Result) -> Result {
	return condition() ? ifTrue : ifFalse
}

extension Optional {

	func unwrapped<Result>(with closure: (Wrapped) -> Result,
												 or: Result) -> Result {
		let result = self.map(closure)
		return result ?? or
	}
	
	func unwrapped(with closure: (Wrapped) -> Wrapped = {(result: Wrapped) -> Wrapped in return result },
								 or: Wrapped) -> Wrapped {
		let result =  self.map(closure)
		return result ?? or
	}
	
}

extension UIButton {
	
	private func image(withColor color: UIColor) -> UIImage? {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		
		context?.setFillColor(color.cgColor)
		context?.fill(rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
	func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
		self.setBackgroundImage(image(withColor: color), for: state)
	}
}

class Button: UIButton {
	
	typealias DidTapButton = () -> Void
	
	var didTouchUpInside: DidTapButton? {
		didSet {
			if didTouchUpInside != nil {
				addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
			} else {
				removeTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
			}
		}
	}
	
	// MARK: - Actions
	
	@objc
	func didTouchUpInside(_ sender: UIButton) {
		if let handler = didTouchUpInside {
			handler()
		}
	}
	
}

extension UIImage {
	
	func overlayWith(image: UIImage, color: UIColor, posX: CGFloat = 0, posY: CGFloat = 0) -> UIImage {
		//		let newWidth = size.width < posX + image.size.width ? posX + image.size.width : size.width
		//		let newHeight = size.height < posY + image.size.height ? posY + image.size.height : size.height
		let newSize = CGSize(width: size.width, height: size.height)
		
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		color.set()
		draw(in: CGRect(origin: CGPoint.zero, size: size))
		let x = size.width/2 - image.size.width/2
		let y = size.height/2 - image.size.height/2
		image.draw(in: CGRect(origin: CGPoint(x: x, y: y), size: image.size))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
}

extension UIColor {
	
	// MARK: - Initialization
	
	convenience init?(hex: String) {
		var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
		
		var rgb: UInt32 = 0
		
		var r: CGFloat = 0.0
		var g: CGFloat = 0.0
		var b: CGFloat = 0.0
		var a: CGFloat = 1.0
		
		let length = hexSanitized.count
		
		guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
		
		if length == 6 {
			r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
			g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
			b = CGFloat(rgb & 0x0000FF) / 255.0
			
		} else if length == 8 {
			r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
			g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
			b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
			a = CGFloat(rgb & 0x000000FF) / 255.0
			
		} else {
			return nil
		}
		
		self.init(red: r, green: g, blue: b, alpha: a)
	}
	
	// MARK: - Computed Properties
	
	var toHex: String? {
		return toHex()
	}
	
	// MARK: - From UIColor to String
	
	func toHex(alpha: Bool = false) -> String? {
		guard let components = cgColor.components, components.count >= 3 else {
			return nil
		}
		
		let r = Float(components[0])
		let g = Float(components[1])
		let b = Float(components[2])
		var a = Float(1.0)
		
		if components.count >= 4 {
			a = Float(components[3])
		}
		
		if alpha {
			return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
		} else {
			return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
		}
	}
	
}

extension Array {
	mutating func remove(atValid index: Int) {
		if indices.contains(index) {
			remove(at: index)
		}
	}
	
	mutating func update(with element: Element, at index: Int) {
		if indices.contains(index) {
			self[index] = element
		}
	}
}
func nonNil(_ value: String?) -> String {
	return value ?? ""
}

extension Optional where Wrapped == Int {
	var forDisplay: String {
		guard let integer = self else {
			return ""
		}
		return "\(integer)"
	}
}
