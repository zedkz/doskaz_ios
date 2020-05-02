//
//  UISearchAppearanceCustomizer.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/1/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

extension UISearchBar {
	func customize() {
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.17)
			.withAlphaComponent(0.3)
			.cgColor
		self.layer.shadowOpacity = 0.6
		self.layer.shadowRadius = 0.7
		self.setImage(UIImage(named: "clear_search"), for: .clear, state: .normal)
		self.setImage(UIImage(), for: .search, state: .normal)
		
		self.showsCancelButton = false
		
		if #available(iOS 13.0, *) {
			self.searchTextField.backgroundColor = UIColor(named: "CategoryPickerHeaderBackground")
			self.searchTextField.textColor = .black
			self.searchTextField.attributedPlaceholder = NSAttributedString(
				string: l10n(.searchPlaceholder),
				attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
			)
			self.searchTextField.leftViewMode = .never
			
		} else {
			let textField = self.value(forKey: "searchField") as? UITextField
			textField?.backgroundColor = UIColor(named: "CategoryPickerHeaderBackground")
			textField?.textColor = .black
			textField?.attributedPlaceholder = NSAttributedString(
				string: l10n(.searchPlaceholder),
				attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
			)
			textField?.leftViewMode = .never
		}
		
	}
}
