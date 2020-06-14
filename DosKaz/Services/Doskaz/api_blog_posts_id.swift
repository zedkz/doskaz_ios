//
//  api_blog_posts_id.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/14/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIBlogPost: DoskazRequest {
	
	var onSuccess = { (singleBlog: SingleBlog) -> Void in
		debugPrint(singleBlog)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	let id: Int
	
	var method: Method { .get }
	
	var path: String { "blog/posts/\(id)" }
		
}

struct SingleBlog: Codable {
	let post: Item
	let similar: [Item]
}

