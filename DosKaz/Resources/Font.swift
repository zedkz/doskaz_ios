//
//  Font.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/28/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

protocol Font {
	func of(size: CGFloat) -> UIFont?
}

extension Font where Self: RawRepresentable, Self.RawValue == String {
	func of(size: CGFloat) -> UIFont? {
		return UIFont(name: rawValue, size: size)
	}
}

enum SFDisplay: String, Font {
	case regular  = ".SFUIDisplay-Regular"
	case semibold = ".SFUIDisplay-Semibold"
	
	func with(size: CGFloat) -> UIFont {
		if let font =  UIFont(name: rawValue, size: size) {
			return font
		} else {
			switch self.rawValue {
			case ".SFUIDisplay-Semibold":
				return UIFont.systemFont(ofSize: size, weight: .semibold)
			case ".SFUIDisplay-Regular":
				return UIFont.systemFont(ofSize: size, weight: .regular)
			default:
				return UIFont.systemFont(ofSize: 13)
			}
			
		}
	}
}



