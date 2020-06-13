//
//  api_regionalRepresentatives.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/13/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIRegionalReps: DoskazRequest {
	
	let onSuccess: ([RegionalRep]) -> Void
	
	let onFailure: (Error) -> Void
	
	var path: String { "regionalRepresentatives" }
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

struct RegionalRep: Codable {
	let id: String
	let name: String
	let email: String
	let phone: String
	let department: String
	let cityId: Int
	let image: String
}
