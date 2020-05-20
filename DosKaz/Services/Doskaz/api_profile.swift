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
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}


// MARK: - Profile
struct Profile: Codable {
	let id: Int
	let email, phone: String?
	let avatar: String?
	let firstName, lastName, middleName: String?
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
