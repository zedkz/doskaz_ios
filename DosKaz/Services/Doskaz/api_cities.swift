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
struct City: Codable, CustomStringConvertible, Equatable {
	let id: Int
	let name: String
	let bounds: [[Double]]
	
	var description: String { name }
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
	
	var authorizationType: AuthorizationType? = .bearer
	
}

// MARK: - Authority
struct Authority: Codable, CustomStringConvertible, Equatable {
	let id: Int
	let name: String
	
	var description: String { name }
}

class AuthoritiesStorage: Archive {
	var fileName: String = "AuthoritiesStorage"
	typealias Model = [Authority]
	
	static let shared = AuthoritiesStorage()
}
