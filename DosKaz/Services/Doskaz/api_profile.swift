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
	
	var authorizationType: AuthorizationType? = .bearer
	
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
	let abilities: [Ability]?
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

// MARK: - User abilities

enum Ability: String, Codable {
	case status_change, avatar_upload
	
	var newAbility: String {
		switch self {
		case .status_change:
			return l10n(.abilityStatusChange)
		case .avatar_upload:
			return l10n(.abilityAvatarUpload)
		}
	}
}
