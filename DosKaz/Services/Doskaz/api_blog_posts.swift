//
//  api_blog_posts.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/14/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIBlogPosts: DoskazRequest {
	
	var onSuccess = { (blogResponse: BlogResponse) -> Void in
		debugPrint(blogResponse)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var page: Int?
	
	var search: String?
		
	var method: Method { .get }
	
	var path: String { "blog/posts" }
	
	var task: Task {
		let parameters: [String: Any?] = [
			"page": page,
			"search": search
		]
		let paramenters = parameters.compactMapValues{ $0 }
		
		return .requestParameters(parameters: paramenters, encoding: URLEncoding.default)
	}
	
}


// MARK: - BlogResponse
struct BlogResponse: Codable {
	let items: [Item]
	let pages: Int
}

// MARK: - Item
struct Item: Codable {
	let id: Int
	let title: String
	let annotation, content: String?
	let slug: String
	let categorySlug: String
	let categoryId: Int
	let categoryTitle: String?
	let publishedAt: Date?
	let previewImage: String?
	let image: String
	let meta: Meta?
	
	var datePublished: String {
		publishedAt?.dayMonthYear ?? ""
	}
	
	var categoryName: String {
		categoryTitle ?? ""
	}
	
	var imagURL: URL? {
		return URL(string: Constants.mainURL + image)
	}
}

// MARK: - Meta
struct Meta: Codable {
	let title, description: String
	let ogTitle, ogDescription, ogImage: String

}
