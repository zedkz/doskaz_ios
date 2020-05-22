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


struct APIAuthorities: DoskazRequest {
	
	var onSuccess = { (authorities: [Authority]) -> Void in
		debugPrint(authorities)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var path: String { "complaints/authorities" }
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

// MARK: - Authority
struct Authority: Codable {
	let id: Int
	let name: String
}

class AuthoritiesStorage: Archive {
	var fileName: String = "AuthoritiesStorage"
	typealias Model = [Authority]
	
	static let shared = AuthoritiesStorage()
}
