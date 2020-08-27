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
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	let feedback: Feedback
	
	var path: String { "feedback" }
	
	var method: Method { .post }
	
	var task: Task {
		return .requestJSONEncodable(feedback)
	}
	
	var authorizationType: AuthorizationType? = .bearer
	
}

struct Feedback: Codable {
	var name: String
	var email: String
	var text: String
}

// MARK: - DKError
struct DKError: Codable, LocalizedError {
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
	
	var errorDescription: String? {
		overallMessage
	}
}

// MARK: - Error
struct MError: Codable {
	let property, message: String
}
