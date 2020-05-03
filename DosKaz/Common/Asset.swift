//
//  Asset.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/3/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

enum Asset: Equatable {
	case fontAwesome(String?)
	case local(String)
	
	var image: UIImage? {
		switch self {
		case .fontAwesome(let name):
			guard let name = name else {
				return nil
			}
			return UIImage.fontAwesomeIcon(
				code: name ,
				style: .solid,
				textColor: UIColor(named: "UnselectedTabbarTintColor") ?? .gray,
				size: CGSize(width: 24, height: 24)
			)
		case .local(let name):
			return UIImage(named: name)
		}
	}
	
}
