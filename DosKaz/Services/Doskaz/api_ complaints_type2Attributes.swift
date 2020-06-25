//
//  api_ complaints_type2Attributes.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/22/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIComplaintAtrs: DoskazRequest {
	
	var onSuccess = { (complaintAtrs: [ComplaintAtr]) -> Void in
		debugPrint(complaintAtrs)
	}
	
	var onFailure = { (error: Error) -> Void in
		debugPrint(error)
	}
	
	var path: String { "complaints/type2Attributes" }
	
	var authorizationType: AuthorizationType? = .bearer
	
}

// MARK: - ComplaintAtr
struct ComplaintAtr: Codable {
	let key, title: String
	let options: [Option]
}

// MARK: - Option
struct Option: Codable {
	let key, label: String
}
