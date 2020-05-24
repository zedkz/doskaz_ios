//
//  ProfileRequests.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIProfileTasks: DoskazRequest {
	
	var onSuccess = { (profileTasks: ProfileTasks) -> Void in
		debugPrint(profileTasks)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var page: Int
	
	var sort: String?
	
	var path: String { "profile/tasks" }
	
	var task: Task {
		let parameters: [String: Any?] = [
			"page": page,
			"sort": sort
		]
		let prs = parameters.compactMapValues{ $0 }
		return .requestParameters(parameters: prs, encoding: URLEncoding.default)
	}
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - ProfileTasks
struct ProfileTasks: Codable {
	let pages: Int
	let items: [ProfileTask]
}

// MARK: - Item
struct ProfileTask: Codable {
	let completedAt: String?
	let createdAt, title: String?
	let points: Int
}
