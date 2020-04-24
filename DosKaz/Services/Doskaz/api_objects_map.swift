//
//  api_objects_map.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

protocol DoskazRequest: MoyaRequest, TargetType { }

extension DoskazRequest {
	var baseURL: URL { return URL(string:"https://doskaz.vps3.zed.kz/api/")! }
}


struct APIObjectsMap: DoskazRequest {
	var onSuccess = { (mapObjects: MapObjects) in
		debugPrint(mapObjects)
	}
	
	var onFailure = { (error: Error) in
		debugPrint(error)
	}
	
	var zoom: Int
	var box: [Double]
	
	var path: String { "objects/map" }
	
	var task: Task {
				
		let stringBox = box.enumerated().reduce("") { (partialResult, args) -> String in
			let (index, element) = args
			let returned = partialResult + String(element)
			let isLastIndex = index == box.count - 1
			return evaluate(isLastIndex, ifTrue: returned, ifFalse: returned + ",")
		}
		
		let p: [String: Any] = [
			"zoom": zoom,
			"bbox": stringBox
		]
		return Task.requestParameters(parameters: p, encoding: URLEncoding.default)
	}
	
}



// MARK: - ObjectsOnMap
struct MapObjects: Codable {
	let clusters: [Cluster]
	let points: [Point]
}

// MARK: - Cluster
struct Cluster: Codable {
	let id: String
	let coordinates: [Double]
	let bbox: [[Double]]
	let itemsCount: Int
}

// MARK: - Point
struct Point: Codable {
	let id: Int
	let coordinates: [Double]
	let color: Color
	let icon: String?
	let overallScore: OverallScore
}

enum Color: String, Codable {
	case de1220 = "#DE1220"
	case f8Ac1A = "#F8AC1A"
	case the3Dba3B = "#3DBA3B"
}

enum OverallScore: String, Codable {
	case fullAccessible = "full_accessible"
	case notAccessible = "not_accessible"
	case partialAccessible = "partial_accessible"
}
