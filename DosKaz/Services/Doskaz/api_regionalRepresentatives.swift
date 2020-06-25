//
//  api_regionalRepresentatives.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/13/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIRegionalReps: DoskazRequest {
	
	let onSuccess: ([RegionalRep]) -> Void
	
	let onFailure: (Error) -> Void
	
	var path: String { "regionalRepresentatives" }
	
	var authorizationType: AuthorizationType? = .bearer
	
}

struct RegionalRep: Codable {
	let id: String
	let name: String
	let email: String
	let phone: String
	let department: String
	let cityId: Int
	let image: String
	
	var imageURL: URL? {
		return URL(string: Constants.mainURL + image)
	}
}
