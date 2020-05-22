//
//  api_cities.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/22/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APICities: DoskazRequest {
	
	var onSuccess = { (cities: [City]) -> Void in
		debugPrint(cities)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var path: String { "cities" }
	
}

// MARK: - City
struct City: Codable {
	let id: Int
	let name: String
	let bounds: [[Double]]
}

class CitiesStorage: Archive {
	var fileName: String = "CitiesStorage"
	typealias Model = [City]
	
	static let shared = CitiesStorage()
}
