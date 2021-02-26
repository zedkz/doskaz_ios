//
//  api_object_id.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/29/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIGetObject: DoskazRequest {
	var onSuccess = { (doskazVenue: DoskazVenue) in
		debugPrint(doskazVenue)
	}
	
	var onFailure = { (error: Error) in
		debugPrint(error)
	}
	
	let id: Int
	
	var path: String { "objects/\(id)" }
		
}

// MARK: - DoskazVenue
struct DoskazVenue: Codable {
	var id: Int?
	let title: String
	let address: String
	let description: String
	let category: String
	let subCategory: String
	let coordinates: [Double]
	let overallScore: OverallScore
	let color: String
	let scoreByZones: ScoreByZones
	let icon: String
	let photos: [Photo]
	let videos: [String]
	let reviews: [Review]
	let history: [History]
	let attributes: Attributes
	let verificationStatus: String
//
	enum CodingKeys: String, CodingKey {
		case id
		case title, address
		case description
		case category,subCategory, coordinates, overallScore, color, scoreByZones, icon, photos, videos, reviews, history, verificationStatus
		case attributes
	}
}

// MARK: - Attributes
struct Attributes: Codable {
	let form: String
	let zones: Zones
}

// MARK: - Zones
struct Zones: Codable {
	let parking, entrance1: [String: FormValue]
	let movement, service, toilet, navigation: [String: FormValue]
	let serviceAccessibility: [String: FormValue]
}

// MARK: - Entrance1
struct Entrance1: Codable {
	let attribute1: String
}

// MARK: - History
struct History: Codable {
	let name: String
	let date: Date
	let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
	let type: String
	
	var displayText: String {
		switch type {
		case "review_created":
			return l10n(.reviewCreated)
		case "verification_rejected":
			return l10n(.verificationRejected)
		case "verification_confirmed":
			return l10n(.verificationConfirmed)
		default:
			return type
		}
	}
}

// MARK: - Photo
struct Photo: Codable {
	let previewUrl, viewUrl, date: String
}

// MARK: - Review
struct Review: Codable {
	let author, text: String
	let createdAt: Date
}

// MARK: - ScoreByZones
struct ScoreByZones: Codable {
	let parking, entrance, movement, service: OverallScore
	let toilet, navigation, serviceAccessibility: OverallScore
	let kidsAccessibility: OverallScore
}


extension DoskazVenue {
	var verificationStatusText: String {
		switch verificationStatus {
		case "not_verified":
			return l10n(.notVerified)
		case "full_verified":
			return l10n(.fullVerified)
		case "partial_verified":
			return l10n(.partiallyVerified)
		default:
			return ""
		}
	}
}
