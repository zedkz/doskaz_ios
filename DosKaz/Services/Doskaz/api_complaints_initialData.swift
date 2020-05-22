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
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - ComplaintData
struct ComplaintData: Codable {
	let complainant: Complainant
	let authorityId: Int
	let rememberPersonalData: Bool
	let objectId: Int
	let content: Content
}

// MARK: - Complainant
struct Complainant: Codable {
	let firstName, lastName, middleName, iin: String?
	let phone, street, building: String?
	let cityId: Int?
	let apartment: String?
}

// MARK: - Content
struct Content: Codable {
	let type: String
	let visitedAt: String
	let objectName: String
	let cityId: Int
	let street, building, office, visitPurpose: String
	let videos: [String]
	let photos: [String]
}
