//
//  PhoneFormatter.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/26/20.
//  Copyright © 2020 zed. All rights reserved.
//
import Foundation

struct PhoneFormatter {
	static func format(phoneNumber: String) -> String {
		let chSet = CharacterSet.decimalDigits
		let cleanPhoneNumber = phoneNumber.components(separatedBy: chSet.inverted).joined()

		let mask = "7(XXX)XXX-XX-XX"
		var result = "+7"
		var index = cleanPhoneNumber.startIndex
		print("Clean:", cleanPhoneNumber)
		for ch in mask {
			if index == cleanPhoneNumber.endIndex {
				break
			}
			print("Ch:", ch)
			
			if ch == "X" {
				result.append(cleanPhoneNumber[index])
				index = cleanPhoneNumber.index(after: index)
			} else if ch == "7" {
				index = cleanPhoneNumber.index(after: index)
			} else {
				result.append(ch)
			}
			
			print("Result:", result)
		}
		return result
	}
	
	
	func getClearNumber(number: String) -> String {
		return number.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
	}
	
}
