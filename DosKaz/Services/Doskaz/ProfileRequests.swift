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
	
	var authorizationType: AuthorizationType? = .bearer
	
}

// MARK: - ProfileTasks
struct ProfileTasks: Codable {
	let pages: Int
	let items: [ProfileTask]
}

// MARK: - Item
struct ProfileTask: Codable {
	let completedAt: String?
	let createdAt: Date?
	let title: String?
	let points: Int
	
	var completedDate: Date? {
		guard let completedAt = completedAt  else {
			return nil
		}
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
		return formatter.date(from: completedAt)
	}
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
			"overallScore": overallScore?.rawValue
		]
		let prs = parameters.compactMapValues{ $0 }
		return .requestParameters(parameters: prs, encoding: URLEncoding.default)
	}
	
	var authorizationType: AuthorizationType? = .bearer
	
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
	
	var description: NSAttributedString {
		let image1 = NSTextAttachment()
		image1.image = UIImage(named: "reviewCount")
		
		let fullString = NSMutableAttributedString(attachment: image1)
		
		let reviewCount = NSAttributedString(string: " \(reviewsCount)  ")
		fullString.append(reviewCount)
		
		let image2 = NSTextAttachment()
		image2.image = UIImage(named: "complaintCount")
		fullString.append(NSAttributedString(attachment: image2))
		
		let complaintsCount = NSAttributedString(string: " \(self.complaintsCount)")
		fullString.append(complaintsCount)
		
		return fullString
	}
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
	
	var authorizationType: AuthorizationType? = .bearer
	
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
	let objectId: Int?
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
	
	var authorizationType: AuthorizationType? = .bearer
	
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
	
	var authorizationType: AuthorizationType? = .bearer
	
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
	
	var authorizationType: AuthorizationType? = .bearer
	
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
			var title: String {
				guard let title = data.title else {
					return ""
				}
				return ": \"\(title)\""
			}
			return l10n(.award_issued) + title
		case .level_reached:
			let currentLevel = "\(l10n(.currentLevel)) \(data.levelString)"
			let nextLevel = "\(l10n(.nextLevel)) \(data.nextLevelString)"
			let newAbility = "\(data.unlockedAbility?.newAbility ?? "")"
			return "\(currentLevel). \(nextLevel). \(newAbility)"
		case .object_reviewed:
			return "\(data.username ?? "X") \(l10n(.hasCommented)) \(data.title ?? "")"
		case .blog_comment_replied:
			return "\(data.username ?? "X") \(l10n(.hasCommentedBlog)) \(data.title ?? "")"
		default:
			return type.rawValue
		}
	}
}

// MARK: - DataClass
struct EventData: Codable {
	let title: String?
	let type: String?
	let level: Int?
	let pointsUntilNextLevel: Int?
	let unlockedAbility: Ability?
	let username: String?

	var levelString: String {
		level.forDisplay
	}
	
	var nextLevelString: String {
		pointsUntilNextLevel.forDisplay
	}
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
	
	var authorizationType: AuthorizationType? = .bearer
	
}

// MARK: - PutProfile
struct PutProfile: Codable {
	var firstName, lastName, middleName, email: String
	var status: String
}

	
//MARK: - Profile update preset avatar

struct APIUpdateAvatarPreset: DoskazRequest {
	let onSuccess: (SVGAvatar) -> Void
	let onFailure: (Error) -> Void
	let avatarNumber: PresetAvatar
	
	var path: String { "profile/chooseAvatarPreset/\(avatarNumber.rawValue)" }
	var method = Method.put
	var authorizationType: AuthorizationType? = .bearer
}

struct SVGAvatar: Codable {
	var avatar: String
}

enum PresetAvatar: Int, Codable {
	case one = 1, two, three, four, five, six
}


struct APIDeleteAvatar: DoskazRequest {
	let onSuccess: (Empty) -> Void
	let onFailure: (Error) -> Void
	var path: String { "profile/avatar" }
	var method: Method { .delete }
	var authorizationType: AuthorizationType? = .bearer
}
