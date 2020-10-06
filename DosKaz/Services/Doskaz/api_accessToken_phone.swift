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
	var path: String { "accessToken/oauth" }
	var method: Method { .post }
	var task: Task {
		.requestJSONEncodable(oauthToken)
	}
}

struct OauthToken: Codable {
	let provider: String
	let code: String
}

enum Provider: String {
	case google, facebook, vkontakte, mailru
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
