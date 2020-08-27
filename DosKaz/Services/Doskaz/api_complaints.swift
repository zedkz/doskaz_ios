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
	
	var onFailure = { (error: DKError) -> Void in
		debugPrint(error)
	}
	
	func parseError(_ moyaError: MoyaError) {
		guard let errorData = moyaError.response?.data else { return }
		guard !errorData.isEmpty else { return }
		do {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			let error = try decoder.decode(DKError.self , from: errorData)
			onFailure(error)
		} catch DecodingError.keyNotFound(let key, let context) {
			print("Failed to decode due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
		} catch DecodingError.typeMismatch(_, let context) {
		print("Failed to decode due to type mismatch – \(context.debugDescription)")
		} catch DecodingError.valueNotFound(let type, let context) {
			print("Failed to decode due to missing \(type) value – \(context.debugDescription)")
		} catch DecodingError.dataCorrupted(_) {
			print("Failed to decode because it appears to be invalid JSON")
		} catch {
			print("Failed to decode : \(error.localizedDescription)")
		}
	}

	let complaintData: ComplaintData
	
	var path: String { "complaints" }
	
	var method: Method { .post }
	
	var task: Task { .requestJSONEncodable(complaintData) }
	
	var authorizationType: AuthorizationType? = .bearer
	
}
