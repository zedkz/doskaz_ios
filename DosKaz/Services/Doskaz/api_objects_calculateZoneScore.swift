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
	
	var authorizationType: AuthorizationType? = .bearer
	
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
