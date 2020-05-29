//
//  APIPostReview.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/29/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIPostReview: DoskazRequest {
	
	var onSuccess = { (empty: Empty) -> Void in
		debugPrint(empty)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	let objectId: Int
	
	let review: PostReview
	
	var path: String { "objects/\(objectId)/reviews" }
	
	var method: Method { .post }
	
	var task: Task {
		return .requestJSONEncodable(review)
	}
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

struct PostReview: Codable {
	let text: String
}
