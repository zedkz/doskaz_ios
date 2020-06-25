//
//  api_objects_checkPresence.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/24/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APICheckPresence: DoskazRequest {
	let onSuccess: (VenuePresence) -> Void
	let onFailure: (Error) -> Void
	var venue: PotentialVenue
	var method: Method { .post }
	var path: String { "objects/checkPresence" }
	var task: Task {
		.requestJSONEncodable(venue)
	}
	var authorizationType: AuthorizationType? = .bearer
}

struct PotentialVenue: Codable, Equatable {
	var name: String
	var otherNames: String
}

struct VenuePresence: Codable {
	var name: Bool
	var otherNames: Bool
}
