//
//  api_objects_search.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/1/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APISearch: DoskazRequest {
	var onSuccess = { (results: SearchResults) in
		debugPrint(results)
	}
	
	var onFailure = { (error: Error) in
		debugPrint(error)
	}
	
	let cityId: Int
	let query: String
	
	var path: String { "objects/search" }
	
	var task: Task {
		return .requestParameters(
			parameters: ["query": query,"cityId": cityId],
			encoding: URLEncoding.default
		)
	}
	
}


struct SearchResult: Codable {
	let id: Int
	let title, address, category: String
	let icon: String?
}

typealias SearchResults = [SearchResult]
