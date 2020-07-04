//
//  api_blog_categories.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/28/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIBlogCategories: DoskazRequest {
	let onSuccess: ([BlogCategory]) -> Void
	let onFailure: (Error) -> Void
	var path: String { "blog/categories" }
}

struct BlogCategory: Codable {
	let id: Int?
	let title: String
}
