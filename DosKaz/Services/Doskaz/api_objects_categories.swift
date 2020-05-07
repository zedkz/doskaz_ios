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


