//
//  api_storage_upload.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/25/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIUpload: DoskazRequest {
	
	var onSuccess = { (uploadResponse: UploadResponse) -> Void in
		debugPrint(uploadResponse)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var image: Data
	
	var path: String { "storage/upload" }
	
	var method: Method { .post }
	
	var task: Task {
		return .requestData(image)
	}
	
	var headers: [String : String]? {
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
	
}

struct UploadResponse: Codable {
	var path: String?
}
