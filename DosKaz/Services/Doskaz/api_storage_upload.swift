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
	
	var authorizationType: AuthorizationType? = .bearer
	
}

struct UploadResponse: Codable {
	var path: String?
}
