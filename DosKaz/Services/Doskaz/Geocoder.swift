//
//  Geocoder.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/26/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

protocol YandexRequest: MoyaRequest, TargetType { }

extension YandexRequest {
	var baseURL: URL { return URL(string:"https://geocode-maps.yandex.ru/1.x/")! }
}

struct Geocoder: YandexRequest {
	
	var onSuccess = { (response: GeoDataResponse) -> Void in
		debugPrint(response)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	let geocode: String
	
	var path: String { "" }
	
	var task: Task {
		let parameters: [String : Any] = [
			"apikey": "c1050142-1c08-440e-b357-f2743155c1ec",
			"geocode": geocode,
			"format": "json",
			"results": 3
		]
		return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
	}

	
}


// MARK: - GeoDataResponse
struct GeoDataResponse: Codable {
	let response: Response
}

// MARK: - Response
struct Response: Codable {
	let geoObjectCollection: GeoObjectCollection
	
	enum CodingKeys: String, CodingKey {
		case geoObjectCollection = "GeoObjectCollection"
	}
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
	let featureMember: [FeatureMember]
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
	let geoObject: GeoObject
	
	enum CodingKeys: String, CodingKey {
		case geoObject = "GeoObject"
	}
}

// MARK: - GeoObject
struct GeoObject: Codable {
	let name: String
	
	enum CodingKeys: String, CodingKey {
		case name
	}
}

