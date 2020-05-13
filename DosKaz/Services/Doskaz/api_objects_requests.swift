//
//  api_objects_requests.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/10/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

struct APIAddObject: DoskazRequest {
	
	var onSuccess = { (noContent: Empty) in
		debugPrint(noContent)
	}
	
	var onFailure = { (error: Error) in
		debugPrint(error)
	}
	
	let fullForm: FullForm
	
	var method: Method { .post }
	
	var path: String { "objects/requests" }
	
	var task: Task { .requestJSONEncodable(fullForm) }
	
	var headers: [String : String]? {
		let token = "MmsVoO2BSj1y50G0x0pStCcdWM14gBtSuWIrs26rvJOTgFgNK4CYMvUVvccEXYCR4b9dhr25cCAishgZOyFaNAEVgjrv9gjLUcmBTtzrLZmkGY0pDQhxaYml9S5WZUr61lNHbqergPFNXKBUIyr6OzP0pB3vUFqSfcibCpbos4Bb"
		return  ["Authorization" : "Bearer \(token)"]
	}
			
}

struct Empty: Codable { }

// MARK: - FullForm
struct FullForm: Codable {
	let form: String
	let first: First
	let parking: FormSection
	let entrance1: FormSection
	let movement: FormSection
	let service: FormSection
	let toilet: FormSection
	let navigation: FormSection
	let serviceAccessibility: FormSection
}

// MARK: - First
struct First: Codable {
	var name, description, otherNames, address: String
	var categoryId: Int
	var point: [Double]
	var videos, photos: [FullFormPhoto]

}

// MARK: - Photo
struct FullFormPhoto: Codable {
	let data: String
}

// MARK: - FormSection

struct FormSection: Codable {
	let attributes: String
	let comment: String
}

// MARK: - Parking
struct FormAttributeGenerator {
	static func generate() -> String {
		
		let attributesNumbers = Array(1...24)
		
		let alltrs = attributesNumbers.enumerated().reduce("") { (partialResult, args) -> String in
			let (index, element) = args
			let atr = "\"attribute\(element)\": \"not_provided\""
			let returned = partialResult + atr
			let isLastIndex = index == attributesNumbers.count - 1
			return evaluate(isLastIndex, ifTrue: returned, ifFalse: returned + ",")
		}
		
		let generated = """
		{
		\(alltrs)
		}
		"""
		print("Generated", generated)
		
		return generated
	}
}


// MARK: - Example

let first = First(
	name: "name",
	description: "desc",
	otherNames: "other",
	address: "adr",
	categoryId: 13,
	point: [3423,32423],
	videos: [FullFormPhoto(data: "dsf")],
	photos: [FullFormPhoto(data: "34")]
)

let parkingSection = FormSection(
	attributes: FormAttributeGenerator.generate(),
	comment: "dsf"
)
let entranceSection = FormSection(
	attributes: FormAttributeGenerator.generate(),
	comment: "dsf"
)

let form = FullForm(
	form: "small",
	first: first,
	parking: parkingSection,
	entrance1: entranceSection,
	movement: parkingSection,
	service: parkingSection,
	toilet: parkingSection,
	navigation: parkingSection,
	serviceAccessibility: parkingSection
)




