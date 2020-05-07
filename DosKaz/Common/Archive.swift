//
//  Archive.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation

protocol Archive {
	associatedtype Model: Codable
	
	var fileName: String { get }
	
	func store(_ model: Model)
	func retrieveData() -> Model?
}

extension Archive {
	func store(_ model: Model) {
		guard let filePath = filePath else { return }
		do {
			let data = try PropertyListEncoder().encode(model)
			let success = NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
			print(success ? "Successful save" : "Save Failed")
		} catch {
			print("Save Failed")
		}
	}
	
	func retrieveData() -> Model? {
		guard let filePath = filePath else { return nil }
		guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else { return nil }
		do {
			let model = try PropertyListDecoder().decode(Model.self, from: data)
			return model
		} catch {
			print("Retrieve Failed")
			return nil
		}
	}
	
	var filePath: String? {
		//1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
		let manager = FileManager.default
		//2 - this returns an array of urls from our documentDirectory and we take the first path
		let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
		//3 - creates a new path component and creates a new file called "Categories" which is where we will store our Categories array.
		let fileUrl = url?.appendingPathComponent(fileName).path
		return fileUrl
	}
	
}

class CategoriesStorage: Archive {
	typealias Model = [Category]
	
	static let shared = CategoriesStorage()
	
	var fileName: String = "Categories"
}
