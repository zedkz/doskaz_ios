//
//  api_complaints_initialData.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/22/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIComplaintData: DoskazRequest {
	
	var onSuccess = { (complaintData: ComplaintData) -> Void in
		debugPrint(complaintData)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var path: String { "complaints/initialData" }
	
	var authorizationType: AuthorizationType? = .bearer
	
}

// MARK: - ComplaintData
struct ComplaintData: Codable {
	var complainant: Complainant
	var authorityId: Int?
	var rememberPersonalData: Bool
	var objectId: Int?
	var content: Content
}

// MARK: - Complainant
struct Complainant: Codable {
	var firstName, lastName, middleName, iin: String?
	var phone, street, building: String?
	var cityId: Int?
	var apartment: String?
}

// MARK: - Content
struct Content: Codable {
	var type: String
	var visitedAt: Date
	var objectName: String
	var cityId: Int?
	var street, building, office, visitPurpose: String
	var videos: [String]
	var photos: [String]
	var threatToLife: Bool = false
	var comment: String = ""
	var options = [String]()
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		type 			 	 = try container.decode(String.self, forKey: .type)
		visitedAt  	 = try container.decode(Date.self, forKey: .visitedAt)
		objectName 	 = try container.decode(String.self, forKey: .objectName)
		cityId 		 	 = try container.decode(Int.self, forKey: .cityId)
		street 		 	 = try container.decode(String.self, forKey: .street)
		building		 = try container.decode(String.self, forKey: .building)
		office 		 	 = try container.decode(String.self, forKey: .office)
		visitPurpose = try container.decode(String.self, forKey: .visitPurpose)
		videos 			 = try container.decode([String].self, forKey: .videos)
		photos 			 = try container.decode([String].self, forKey: .photos)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(type, forKey: .type)
		try container.encode(visitedAt.iso8601, forKey: .visitedAt)
		try container.encode(objectName, forKey: .objectName)
		try container.encode(cityId, forKey: .cityId)
		try container.encode(street, forKey: .street)
		try container.encode(building, forKey: .building)
		try container.encode(office, forKey: .office)
		try container.encode(visitPurpose, forKey: .visitPurpose)
		try container.encode(videos, forKey: .videos)
		try container.encode(photos, forKey: .photos)
		if type == "complaint2" {
			try container.encode(threatToLife, forKey: .threatToLife)
			try container.encode(comment, forKey: .comment)
			try container.encode(options, forKey: .options)
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case type, visitedAt, objectName, cityId
		case street, building, office, visitPurpose
		case videos, photos
		
		case threatToLife
		case comment
		case options
	}
}

class ComplaintDataStorage: Archive {
	typealias Model = ComplaintData
	var fileName: String = "ComplaintDataStorage"
	static let shared = ComplaintDataStorage()
}

