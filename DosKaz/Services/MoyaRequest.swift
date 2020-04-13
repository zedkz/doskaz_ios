//
//  NetworkService.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/1/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Moya

// MARK: - TargetType defaults

extension TargetType {
	var path: String  								 { return "/" }
	var method: Moya.Method 					 { return .get }
	var task: Task 				 						 { return .requestPlain }
	var headers: [String : String]? 	 { return nil }
	var validationType: ValidationType { return .successCodes }
	var sampleData: Data 							 { return Data("Sample Data".utf8) }
}

// MARK: - BaseService with Codable

protocol MoyaRequest {

	associatedtype CodableRoot: Codable
	associatedtype CustomError: Error
	
	func parseData(_ data: Data)
	func parseError(_ moyaError: MoyaError)
		
	var onSuccess: (CodableRoot) -> Void { get }
	var onFailure: (CustomError) -> Void { get }
	
}

extension MoyaRequest {
	
	private func thereIs(_ data: Data) -> Bool {
		let decoder = JSONDecoder()
		if !data.isEmpty {
			return true
		} else {
			if let emptyJSONObjectData = "{}".data(using: .utf8),
				let emptyDecodableValue = try? decoder.decode(CodableRoot.self, from: emptyJSONObjectData) {
				onSuccess(emptyDecodableValue)
			} else if let emptyJSONArrayData = "[{}]".data(using: .utf8),
				let emptyDecodableValue = try? decoder.decode(CodableRoot.self, from: emptyJSONArrayData) {
				onSuccess(emptyDecodableValue)
			}
			return false
		}
	}
	
	func parseData(_ data: Data) {
		guard thereIs(data) else { return }
		
		do {
			let rootObject = try JSONDecoder().decode(CodableRoot.self , from: data)
			onSuccess(rootObject)
		} catch {
			print("Data can't be parsed into json")
		}
	}
	
	func parseError(_ moyaError: MoyaError) {
		switch (moyaError is CustomError) {
		case true:
			let moyaError = moyaError as! CustomError
			onFailure(moyaError)
		case false:
			guard let errorData = moyaError.response?.data else { return }
			guard thereIs(errorData) else { return }
			// Serialize the errorData
		}
	}
	
	private func onMoyaRequestCompletion(_ result: Result<Moya.Response, MoyaError>) {
		switch result {
		case let .success(response):
			parseData(response.data)
		case let .failure(moyaError):
			parseError(moyaError)
		}
	}
		
}

let multiProvider = MoyaProvider<MultiTarget>()

extension MoyaRequest where Self: TargetType {
	func dispatch() {
		let multiTarget = MultiTarget(self)
		multiProvider.request(multiTarget, completion: onMoyaRequestCompletion)
	}
}


// MARK: - Swapi Example

protocol SwapiRequest: MoyaRequest, TargetType { }

extension SwapiRequest {
	var baseURL: URL { return URL(string:"https://swapi.co/api/")! }
}

struct PersonRequest: SwapiRequest {
	
	var onSuccess = { (character: SWCharacter) in
		debugPrint(character)
	}
	
	var onFailure = { (error: Error) in
		debugPrint(error)
	}
	
	var path: String { return "people/4"}
		
}

struct SWCharacter: Codable {
	
	let name, height, mass, hairColor: String
	let skinColor, eyeColor, birthYear, gender: String
	let homeworld: String
	
	enum CodingKeys: String, CodingKey {
		case name, height, mass
		case hairColor = "hair_color"
		case skinColor = "skin_color"
		case eyeColor = "eye_color"
		case birthYear = "birth_year"
		case gender, homeworld
	}
	
}