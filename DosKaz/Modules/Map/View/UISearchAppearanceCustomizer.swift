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
		self.layer.shadowColor = UIColor(named: "CategoryPickerHeaderBackground")?.cgColor
		self.layer.shadowOpacity = 0.6
		self.layer.shadowRadius = 2
		self.setImage(UIImage(named: "clear_search"), for: .clear, state: .normal)
		
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
