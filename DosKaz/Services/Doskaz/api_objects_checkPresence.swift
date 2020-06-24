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
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
}

struct PotentialVenue: Codable, Equatable {
	var name: String
	var otherNames: String
}

struct VenuePresence: Codable {
	var name: Bool
	var otherNames: Bool
}
