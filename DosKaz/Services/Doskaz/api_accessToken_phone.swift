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
