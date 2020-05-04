//
//  Filter.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/4/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation

class Filter {
	var acc: [OverallScore: Bool]
	
	init() {
		self.acc = [
			OverallScore.fullAccessible: true,
			OverallScore.partialAccessible: false,
			OverallScore.notAccessible: true
		]
		
	}
	
	func icon(_ score: OverallScore) -> String {
		acc[score]?.accIcon ?? ""
	}
}

extension Bool {
	var accIcon: String {
		evaluate(self, ifTrue: "check_activated", ifFalse: "check_not_activated")
	}
}
