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
