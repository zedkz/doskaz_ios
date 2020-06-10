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


//MARK: - Profile objects

struct APIProfileObjects: DoskazRequest {
	
	var onSuccess = { (profileObjects: ProfileObjects) -> Void in
		debugPrint(profileObjects)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var page: Int
	
	var sort: String?
	
	var overallScore: OverallScore?
	
	var path: String { "profile/objects" }
	
	var task: Task {
		let parameters: [String: Any?] = [
			"page": page,
			"sort": sort,
			"overallScore": overallScore
		]
		let prs = parameters.compactMapValues{ $0 }
		return .requestParameters(parameters: prs, encoding: URLEncoding.default)
	}
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - ProfileObjects
struct ProfileObjects: Codable {
	let pages: Int
	let items: [ProfileObject]
}

// MARK: - Item
struct ProfileObject: Codable {
	let id: Int
	let title: String
	let date: Date
	let overallScore: OverallScore
	let reviewsCount, complaintsCount: Int
	let image: String
}


//MARK: - Profile comments

struct APIProfileComments: DoskazRequest {
	
	var onSuccess = { (profileComments: ProfileComments) -> Void in
		debugPrint(profileComments)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var page: Int
	
	var sort: String?
	
	var path: String { "profile/comments" }
	
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

// MARK: - ProfileComments
struct ProfileComments: Codable {
	let pages: Int
	let items: [CommentItem]
}

// MARK: - Item
struct CommentItem: Codable {
	let date: Date
	let type: String
	let objectId: Int
	let title, text: String
}


//MARK: - Profile complaints

struct APIProfileComplaints: DoskazRequest {
	
	var onSuccess = { (profileComplaints: ProfileComplaints) -> Void in
		debugPrint(profileComplaints)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var page: Int
	
	var sort: String?
	
	var path: String { "profile/complaints" }
	
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

// MARK: - ProfileComplaints
struct ProfileComplaints: Codable {
	let pages: Int
	let items: [ComplaintItem]
}

// MARK: - Item
struct ComplaintItem: Codable {
	let id: Int
	let type: ComplaintType
	let title: String
	let date: Date
	let image: String
}


//MARK: - Profile awards

struct APIProfileAwards: DoskazRequest {
	
	var onSuccess = { (profileAwards: [ProfileAward]) -> Void in
		debugPrint(profileAwards)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var path: String { "profile/awards" }
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - ProfileAward
struct ProfileAward: Codable {
	let id, title: String
	let type: AwardType
}

enum AwardType: String, Codable {
	case bronze, silver, gold
}


//MARK: - Profile events

struct APIProfileEvents: DoskazRequest {
	
	var onSuccess = { (profileEvents: ProfileEvents) -> Void in
		debugPrint(profileEvents)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var path: String { "profile/events" }
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - ProfileEvents
struct ProfileEvents: Codable {
	let items: [EventItem]
}

// MARK: - Item
struct EventItem: Codable {
	let userId: Int
	let date: Date
	let type: ProfileEventType
	let data: EventData
	
	var description: String {
		switch type {
		case .award_issued:
			return "Award issued"
		default:
			return type.rawValue
		}
	}
}

// MARK: - DataClass
struct EventData: Codable {
	let title: String?
	let type: String?
}

enum ProfileEventType: String, Codable {
	case award_issued, level_reached
	case object_reviewed, blog_comment_replied, object_added
}


//MARK: - Profile update

struct APIUpdateProfile: DoskazRequest {
	
	let onSuccess: (Empty) -> Void
	
	let onFailure: (Error) -> Void
			
	let profile: PutProfile
	
	var path: String { "profile" }
	
	var method: Method { .put }
	
	var task: Task { .requestJSONEncodable(profile) }
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - PutProfile
struct PutProfile: Codable {
	var firstName, lastName, middleName, email: String
	var status: String
}

	
