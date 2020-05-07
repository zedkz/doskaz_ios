//
//  Filter.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/4/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation

typealias SubCategory = Category

class Filter: Codable {
	
	static var shared: Filter = {
		if let filter = FilterStorage.shared.retrieveData() {
			return filter
		} else {
			let filter = Filter()
			FilterStorage.shared.store(filter)
			return filter
		}
	}()

	var acc: [OverallScore: Bool]
	var cat: [Category] {
		didSet {
			var catStatus = [Category: [SubCategory: Bool]]()
			cat.forEach { category in
				let subCategoryStatuses = category.subCategories.map { subCategory in
					return (subCategory, self.catStatus[category]?[subCategory] ?? false)
				}
				catStatus[category] = Dictionary(uniqueKeysWithValues: subCategoryStatuses)
			}
			self.catStatus = catStatus
		}
	}
	
	var catStatus = [Category: [SubCategory: Bool]]()
	
	init() {
		self.acc = [
			OverallScore.fullAccessible: false,
			OverallScore.partialAccessible: false,
			OverallScore.notAccessible: false
		]
		
		self.cat = [Category]()
		
	}
	
	func reset(){
		for (overallScore, _) in acc {
			acc[overallScore] = false
		}
		
		for (category, subStatuses) in catStatus {
			for (subCategory, _) in subStatuses {
				catStatus[category]?[subCategory] = false
			}
		}
		
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
		let counts = count(for: category)
		return counts.picked < counts.all
	}
	
	func count(for category: Category) -> (picked:Int,all:Int) {
		guard let subStatuses = catStatus[category] else { return (0,0) }
		let statuses = subStatuses.map { $1 }
		let onlyTrue = statuses.filter { $0 == true }
		return (onlyTrue.count,statuses.count)
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


class FilterStorage: Archive {
	typealias Model = Filter
	
	static let shared = FilterStorage()
	
	var fileName: String = "FilterStorageFile"
}

