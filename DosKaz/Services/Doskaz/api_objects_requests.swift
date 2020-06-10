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
		let token = "BVaWWzuih9X4MYfBb1bqYRYrL8rCfNII6ClYz2Jn5B7EBZiQ34TSO4XiaGraZi2k5UXBR5d8O0o2kLfE08gO7Plla7Tr9ypdWH7pCWpKMX9SXCDUi2O5tT7sz8Pct8dB7iUk89YyGgLsrlBbnPiiiD1dgt2ym4twFi50DbSQFU1t"
		return  ["Authorization" : "Bearer \(token)"]
	}
			
}

struct Empty: Codable { }

// MARK: - FullForm
struct FullForm: Codable {
	let form: String
	var first: First
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
	var videos, photos: [String]
}

// MARK: - FormSection

struct FormSection: Codable {
	let attributes: [String: FormValue]
	let comment: String
}

enum FormValue: String, CustomStringConvertible, CaseIterable, Codable{
	case yes
	case no
	case unknown
	case not_provided
	
	var description: String {
		switch self {
		case .yes:
			return "Да"
		case .no:
			return "Нет"
		case .unknown:
			return "Неизвестно"
		case .not_provided:
			return "Не предусмотрено"
		}
	}
	
	var visual: NSAttributedString {
		switch self {
		case .yes:
			return text(" Да", imageName: "green_check")
		case .no:
			return text(" Нет", imageName: "red_check")
		case .unknown:
			return text(" Неизвестно", imageName: "question_check")
		case .not_provided:
			return text(" Не предусмотрено", imageName: "nan_check")
		}
	}
	
	func text(_ string: String, imageName: String) -> NSMutableAttributedString {
		let image1Attachment = NSTextAttachment()
		image1Attachment.image = UIImage(named: imageName)
		let fullString = NSMutableAttributedString(attachment: image1Attachment)
		let text = NSAttributedString(string: string)
		fullString.append(text)
		return fullString
	}
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

//let first = First(
//	name: "name",
//	description: "desc",
//	otherNames: "other",
//	address: "adr",
//	categoryId: 13,
//	point: [3423,32423],
//	videos: ["youtube_link"],
//	photos: ["linktostoredfileindoskaz"]
//)
//
//let parkingSection = FormSection(
//	attributes: FormAttributeGenerator.generate(),
//	comment: "dsf"
//)
//let entranceSection = FormSection(
//	attributes: FormAttributeGenerator.generate(),
//	comment: "dsf"
//)

//let form = FullForm(
//	form: "small",
//	first: first,
//	parking: ["":""],
//	entrance1: entranceSection,
//	movement: parkingSection,
//	service: parkingSection,
//	toilet: parkingSection,
//	navigation: parkingSection,
//	serviceAccessibility: parkingSection
//)
//



