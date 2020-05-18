//
//  api_profile.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/18/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIProfile: DoskazRequest {
	
	var onSuccess = { (profile: Profile) -> Void in
		debugPrint(profile)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var path: String { "profile" }
	
	var headers: [String : String]? {
		let token = "MmsVoO2BSj1y50G0x0pStCcdWM14gBtSuWIrs26rvJOTgFgNK4CYMvUVvccEXYCR4b9dhr25cCAishgZOyFaNAEVgjrv9gjLUcmBTtzrLZmkGY0pDQhxaYml9S5WZUr61lNHbqergPFNXKBUIyr6OzP0pB3vUFqSfcibCpbos4Bb"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}


// MARK: - Profile
struct Profile: Codable {
	let id: Int
	let email, phone: String
	let avatar: String?
	let firstName, lastName, middleName: String
	let currentTask: CurrentTask
	let level: Level
	let stats: Stats
	let abilities: [String]?
	let status: String?
}

// MARK: - CurrentTask
struct CurrentTask: Codable {
	let progress: Int
	let title: String
	let pointsReward: Int
}

// MARK: - Level
struct Level: Codable {
	let current, currentPoints, progressToNext, nextLevelThreshold: Int
}

// MARK: - Stats
struct Stats: Codable {
	let objects, complaints: Int
}
