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
	
	var authorizationType: AuthorizationType? = .bearer
	
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


struct APIPostBlogComments: DoskazRequest {
	
	let onSuccess: (Empty) -> Void
	
	let onFailure: (Error) -> Void
	
	let id: Int
	
	var comment: BlogCommentPost
	
	var method: Method { .post }
	
	var path: String { "blog/posts/\(id)/comments" }
	
	var task: Task {
		.requestJSONEncodable(comment)
	}
	
	var authorizationType: AuthorizationType? = .bearer
	
}

struct BlogCommentPost: Codable {
	var text: String
	var parentId: String?
}
