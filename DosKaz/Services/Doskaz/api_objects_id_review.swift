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
	
	var authorizationType: AuthorizationType? = .bearer
	
}

struct PostReview: Codable {
	let text: String
}


//MARK: - Verification
struct APIVerifyObject: DoskazRequest {
	let onSuccess: (Empty) -> Void
	let onFailure: (Error) -> Void
	let id: Int
	let status: Status
	var method: Method { .post }
	var path: String { "objects/\(id)/verification/\(status)" }
	
	var authorizationType: AuthorizationType? = .bearer
}

enum Status: String {
	case confirm, reject
}
