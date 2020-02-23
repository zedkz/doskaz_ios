//
//  StringResourceGenerator.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/23/20.
//  Copyright © 2020 zed. All rights reserved.
//



/// Generates Localizable string files from
/// LocalizableStringKeyValue enum
struct StringResourceGenerator {
	func generate() {
		let all = LocalizableStringKeyValue.allCases
		for element in all {
			print("key: \(element)","value:", element.rawValue)
		}
	}
}


