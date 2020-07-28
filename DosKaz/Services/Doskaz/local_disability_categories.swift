//
//  local_disability_categories.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/9/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation

struct DisabilityCategories {
	func load() -> [Disability] {
		guard let url = Bundle.main.url(forResource: "disabilityCategories", withExtension: "json") else {
			print("There is no disabilityCategories in the bundle")
			return []
		}
		guard let data = try? Data(contentsOf: url) else {
			fatalError("Failed to load disabilityCategories.json from bundle.")
		}
		
		let decoder = JSONDecoder()
		
		do {
			let disabilities = try decoder.decode([Disability].self, from: data)
			return disabilities
		} catch {
			print("DisabilityCategories decoding failed:\(error.localizedDescription)")
			return []
		}
	}
	
}

// MARK: - DisabilityElement
struct Disability: Codable {
	let key, title, kazTitle, categoryForAPI, icon: String
	var localizedTitle: String {
		switch AppSettings.language {
			case .kazakh: return kazTitle
			case .russian: return title
			case .none: return title
		}
	}
}
