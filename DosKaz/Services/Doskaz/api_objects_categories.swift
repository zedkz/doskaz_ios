//
//  api_objects_categories.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/5/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APICategories: DoskazRequest {
	var onSuccess = { (categories: [Category]) in
		
	}
	
	var onFailure = { (error: Error) in
		
	}
	
	var path: String { "objects/categories" }

}



// MARK: - CategoryElement
struct Category: Codable, Equatable, Hashable {
	let id: Int
	let title: String
	let icon: String?
	let subCategories: [Category]
}


class CategoriesStorage {
	
	static let shared = CategoriesStorage()
	
	func store(_ categories: [Category]) {
		guard let filePath = filePath else { return }
		do {
			let data = try PropertyListEncoder().encode(categories)
			let success = NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
			print(success ? "Successful save" : "Save Failed")
		} catch {
			print("Save Failed")
		}
	}
	
	func retrieveCategories() -> [Category] {
		guard let filePath = filePath else { return [] }
		guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else { return [] }
		do {
			let categories = try PropertyListDecoder().decode([Category].self, from: data)
			return categories
		} catch {
			print("Retrieve Failed")
			return []
		}
	}
	
	var filePath: String? {
		//1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
		let manager = FileManager.default
		//2 - this returns an array of urls from our documentDirectory and we take the first path
		let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
		//3 - creates a new path component and creates a new file called "Categories" which is where we will store our Categories array.
		let fileUrl = url?.appendingPathComponent("Categories").path
		return fileUrl
	}
	
}
