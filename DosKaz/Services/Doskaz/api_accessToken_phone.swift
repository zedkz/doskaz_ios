//
//  api_accessToken_phone.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/18/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIGetPhoneToken: DoskazRequest {
	
	let onSuccess: (DKToken) -> Void
	
	let onFailure: (Error) -> Void
	
	let fireBaseToken: FireToken
	
	var path: String { "accessToken/phone" }
	
	var method: Method { .post }
	
	var task: Task {
		.requestJSONEncodable(fireBaseToken)
	}

}

struct DKToken: Codable {
	let token: String
}

struct FireToken: Codable {
	var idToken: String
}

struct APIGetOauthToken: DoskazRequest {
	let onSuccess: (DKToken) -> Void
	let onFailure: (MoyaError) -> Void
	let oauthToken: OauthToken
	var path: String { "accessToken/\(oauthToken.provider)" }
	var method: Method { .post }
	var task: Task {
		.requestJSONEncodable(oauthToken.accessToken)
	}
	var headers: [String : String]? {
		return ["Content-Type": "application/json"]
	}
}

struct OauthToken: Codable {
	let provider: String
	let accessToken: Token
	
	init(provider: String, accessToken: String) {
		self.provider = provider
		self.accessToken = Token(token: accessToken)
	}
	
	struct Token: Codable {
		let token: String
	}
}

enum Provider: String {
	case google, facebook, vk, mailru
}

// MARK: Sign in with Apple

struct APITokenWithAppleSignIn: DoskazRequest {
	let appleToken: AppleToken
	let onSuccess: (DKToken) -> Void
	let onFailure: (MoyaError) -> Void
	var path: String { "accessToken/apple" }
	var method: Method { .post }
	var task: Task {
		.requestJSONEncodable(appleToken)
	}
}

struct AppleToken: Codable {
	let token: String
}
