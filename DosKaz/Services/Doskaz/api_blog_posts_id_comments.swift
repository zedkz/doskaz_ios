//
//  api_blog_posts_id_comments.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIBlogComments: DoskazRequest {
	
	let onSuccess: (CommentResponse) -> Void
	
	let onFailure: (Error) -> Void
	
	let sortOrder: String
	
	let id: Int
		
	var path: String { "blog/posts/\(id)/comments" }
	
	var task: Task {
		.requestParameters(parameters: ["sortBy": "createdAt", "sortOrder": sortOrder], encoding: URLEncoding.default)
	}
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

struct CommentResponse: Codable {
	let count: Int
	let items: [Comment]
}

struct Comment: Codable {
	let id: String
	let userId: Int
	let userName: String
	let userAvatar: String
	let text: String
	let createdAt: Date
	let parentId: String?
	let replies: [Comment]
}
