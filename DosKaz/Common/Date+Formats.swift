//
//  Date+Formats.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/30/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation

extension Date {
	var dayMonth: String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.setLocalizedDateFormatFromTemplate("d MMM")
		return formatter.string(from: self)
	}
}