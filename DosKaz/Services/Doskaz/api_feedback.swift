//
//  api_feedback.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/29/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIPostFeedback: DoskazRequest {
	
	var onSuccess = { (empty: Empty) -> Void in
		debugPrint(empty)
	}
	
	var onFailure = { (error: DKError) -> Void in
		debugPrint(error)
	}
	
	let feedback: Feedback
	
	var path: String { "feedback" }
	
	var method: Method { .post }
	
	var task: Task {
		return .requestJSONEncodable(feedback)
	}
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

struct Feedback: Codable {
	let name: String
	let email: String
	let text: String
}

// MARK: - DKError
struct DKError: Codable, Error {
	let message: String
	let code: Int
	let errors: [MError]
	
	var overallMessage: String {
		var text = ""
		
		for error in errors {
			let message = error.property + " " + error.message
			text.append(message)
		}
		
		return text
	}
}

// MARK: - Error
struct MError: Codable {
	let property, message: String
}
