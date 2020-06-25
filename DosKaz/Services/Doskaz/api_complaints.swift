//
//  api_complaints.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/22/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIPostComplaint: DoskazRequest {
	
	var onSuccess = { (empty: Empty) -> Void in
		debugPrint(empty)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	let complaintData: ComplaintData
	
	var path: String { "complaints" }
	
	var method: Method { .post }
	
	var task: Task { .requestJSONEncodable(complaintData) }
	
	var authorizationType: AuthorizationType? = .bearer
	
}
