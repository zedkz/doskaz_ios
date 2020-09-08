//
//  api_objects_map.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct Constants {
	static var mainURL: String {
		#if DEBUG
			return "https://doskaz.vps3.zed.kz"
		#else
			return "https://doskaz.kz"
		#endif
	}
}

protocol DoskazRequest: MoyaRequest, TargetType, AccessTokenAuthorizable { }

extension DoskazRequest {
	var baseURL: URL { return URL(string:"\(Constants.mainURL)/api/")! }
	var authorizationType: AuthorizationType? { nil }
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
		
		let p: [String: Any?] = [
			"zoom": zoom,
			"bbox": stringBox,
			"categories": Filter.shared.subCategoriesIds,
			"accessibilityLevels": Filter.shared.accessibilityLevels,
			"disabilitiesCategory": AppSettings.disabilitiesCategory?.values.first
		]
		return Task.requestParameters(parameters: p.compactMapValues{$0}, encoding: URLEncoding.default)
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
	let color: String
	let icon: String?
	let overallScore: OverallScore
}

extension String {
	var uiColor: UIColor {
		return UIColor(hex: self) ?? .gray
	}
}

enum OverallScore: String, Codable {
	case fullAccessible = "full_accessible"
	case notAccessible = "not_accessible"
	case partialAccessible = "partial_accessible"
	case notProvided = "not_provided"
	case unKnown = "unknown"
}

extension OverallScore: CustomStringConvertible, CaseIterable {
	var description: String {
		switch self {
		case .fullAccessible: return l10n(.accessibleFull)
		case .partialAccessible: return l10n(.accessiblePartial)
		case .notAccessible: return l10n(.accessibleNone)
		case .notProvided: return l10n(.accessbleNotProvided)
		case .unKnown: return l10n(.accessibleUnknown)
		}
	}
}
