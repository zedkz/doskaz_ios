//
//  Filter.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/4/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation

typealias SubCategory = Category

class Filter {
	
	static let shared = Filter()
	
	var acc: [OverallScore: Bool]
	var cat: [Category] {
		didSet {
			var catStatus = [Category: [SubCategory: Bool]]()
			cat.forEach { category in
				let subCategoryStatuses = category.subCategories.map { subCategory in
					return (subCategory,false)
				}
				catStatus[category] = Dictionary(uniqueKeysWithValues: subCategoryStatuses)
			}
			self.catStatus = catStatus
		}
	}
	
	var catStatus = [Category: [SubCategory: Bool]]()
	
	init() {
		self.acc = [
			OverallScore.fullAccessible: true,
			OverallScore.partialAccessible: false,
			OverallScore.notAccessible: true
		]
		
		self.cat = [Category]()
		
	}
	
	func icon(_ score: OverallScore) -> String {
		acc[score]?.accIcon ?? ""
	}
	
	func icon(_ category: Category, sub: SubCategory) -> String {
		return catStatus[category]?[sub]?.accIcon ?? ""
	}
	
	func toggle(_ category: Category, _ subCategory: SubCategory) {
		catStatus[category]?[subCategory]?.toggle()
	}
	
	func toggleAll(for category: Category) {
		guard let subStatuses = catStatus[category] else { return }
		let isNotAllPicked = self.isNotAllPicked(for: category)
		for (key, _) in subStatuses {
			catStatus[category]![key] = isNotAllPicked
		}
	}
	
	func isNotAllPicked(for category: Category) -> Bool {
		guard let subStatuses = catStatus[category] else { return false }
		let firstFalse = subStatuses.map { $1 }.first{ $0 == false }
		let isNotAllPicked = firstFalse != nil
		return isNotAllPicked
	}
	
	func count(for category: Category) -> Int {
		guard let subStatuses = catStatus[category] else { return 0 }
		let onlyTrue = subStatuses.map { $1 }.filter { $0 == true }
		return onlyTrue.count
	}
	
	func iconPickAll(for category: Category) -> String {
		return (!isNotAllPicked(for: category)).accIcon
	}
	
}

extension Bool {
	var accIcon: String {
		evaluate(self, ifTrue: "check_activated", ifFalse: "check_not_activated")
	}
}
