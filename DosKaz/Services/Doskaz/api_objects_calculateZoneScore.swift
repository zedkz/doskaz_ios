//
//  api_objects_calculateZoneScore.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APICalculateZoneScore: DoskazRequest {
	
	var onSuccess = { (zoneScore: ZoneScore) -> Void in
		debugPrint(zoneScore)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	let zoneParameters: ZoneParameters
	
	var path: String { "objects/calculateZoneScore" }
	
	var method: Method { .post }
	
	var task: Task {
		return .requestJSONEncodable(zoneParameters)
	}
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - ZoneScore
struct ZoneScore: Codable {
	let movement, limb, vision, hearing: OverallScore
	let intellectual: OverallScore
}

struct ZoneParameters: Codable {
	var type: String
	var attributes: [String: FormValue]
}
