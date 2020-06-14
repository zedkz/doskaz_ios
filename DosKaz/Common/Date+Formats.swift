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
	
	var dayMonthYear: String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.setLocalizedDateFormatFromTemplate("d MMM yyyy")
		return formatter.string(from: self)
	}
	
	var dayMonthTime: String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.setLocalizedDateFormatFromTemplate("d MMM, HH:mm")
		return formatter.string(from: self)
	}
	
	var full: String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.setLocalizedDateFormatFromTemplate("d MMM yyyy HH:mm")
		return formatter.string(from: self)
	}
	
	var iso8601: String {
		let formatter = ISO8601DateFormatter()
		return formatter.string(from: self)
	}
}
