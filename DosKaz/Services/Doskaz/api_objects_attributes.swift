//
//  api_objects_attributes.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/10/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIFormAttributes: DoskazRequest {
	
	var onSuccess = { (formAttributes: FormAttributes) in
		debugPrint(formAttributes)
	}
	
	var onFailure = { (error: Error) in
		debugPrint(error)
	}
	
	var path: String { "objects/attributes" }
	
}

// MARK: - FormAttributes
struct FormAttributes: Codable {
	let small: Full
	let middle: Full
	let full: Full
}

// MARK: - Full
struct Full: Codable {
	let parking: [Group]
	let entrance: [Group]
	let movement: [Group]
	let service: [Group]
	let toilet: [Group]
	let navigation: [Group]
	let serviceAccessibility: [Group]
}

// MARK: - Group
struct Group: Codable {
	let title: String?
	let subGroups: [SubGroup]?
}

struct SubGroup: Codable {
	var title: String?
	var attributes: [Attribute]?
}

struct Attribute: Codable {
	var key: Int
	var title: String?
	var subTitle: String?
	
	var finalTitle: String {
		var finalTitle = ""
	
		switch (title, subTitle) {
		case (.some(let title), .some(let subtitle)):
			finalTitle = title + ". " +  subtitle
		case (.some(let title), .none):
			finalTitle = title
		case (.none, .some(let subTitle)):
			finalTitle = subTitle
		case (.none, .none):
			break
		}
		return finalTitle
	}
}

class FormAttributesStorage: Archive {
	typealias Model = FormAttributes
	
	static let shared = FormAttributesStorage()
	
	var fileName: String = "FormAttributesStorage"
}
