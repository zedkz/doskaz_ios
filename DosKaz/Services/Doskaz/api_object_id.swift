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
	let title: String
	let address: String
	let description: String
	let category: String
	let subCategory: String
	let coordinates: [Double]
	let overallScore: OverallScore
	let scoreByZones: ScoreByZones
	let icon: String
	let photos: [Photo]
	let videos: [String]
	let reviews: [Review]
	let history: [History]
//	let attributes: Attributes
	let verificationStatus: String
//
	enum CodingKeys: String, CodingKey {
		case title, address
		case description
		case category,subCategory, coordinates, overallScore, scoreByZones, icon, photos, videos, reviews, history, verificationStatus
//		case attributes
	}
}

// MARK: - Attributes
struct Attributes: Codable {
	let form: String
	let zones: Zones
}

// MARK: - Zones
struct Zones: Codable {
	let parking, entrance1, entrance2, entrance3: Entrance1
	let movement, service, toilet, navigation: Entrance1
	let serviceAccessibility: Entrance1
}

// MARK: - Entrance1
struct Entrance1: Codable {
	let attribute1: String
}

// MARK: - History
struct History: Codable {
	let name, date: String
	let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
	let type: String
}

// MARK: - Photo
struct Photo: Codable {
	let previewUrl, viewUrl, date: String
}

// MARK: - Review
struct Review: Codable {
	let author, text, date: String
}

// MARK: - ScoreByZones
struct ScoreByZones: Codable {
	let parking, entrance, movement, service: OverallScore
	let toilet, navigation, serviceAccessibility: OverallScore
}
