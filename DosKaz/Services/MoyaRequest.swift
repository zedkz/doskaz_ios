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
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			let rootObject = try decoder.decode(CodableRoot.self , from: data)
			onSuccess(rootObject)
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
	
	func parseError(_ moyaError: MoyaError) {
		switch MoyaError.self == CustomError.self {
		case true:
			let moyaError = moyaError as! CustomError
			onFailure(moyaError)
		case false:
			guard let errorData = moyaError.response?.data else { return }
			print("Unserialized error data",errorData)
			// Serialize the errorData
		}
	}
	
	private func onMoyaRequestCompletion(_ result: Result<Moya.Response, MoyaError>) {
		let defaultEntryDateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.timeStyle = .short
			formatter.dateStyle = .short
			return formatter
		}()
		
		let entry:(String,String) -> String = { (identifier, message) in
			let date = defaultEntryDateFormatter.string(from: Date())
			return """
			---------------------------------------------------------------------------------------------
			||| Moya_Logger: [\(date)] \(identifier):\n\(message)
			---------------------------------------------------------------------------------------------
			"""
		}
		switch result {
		case let .success(response):
			let message = """
			||| [ Status Code: \(response.statusCode) ]
			||| [ Method: \(response.request?.httpMethod ?? "Method is unknown")]
			||| [ URL: \(response.request?.url?.description ?? "Path is unknown")]
			"""
			print(entry("Response", message))
//			print("Data,", String(data:response.data, encoding: .utf8) ?? "no data")

			parseData(response.data)
		case let .failure(moyaError):

			if let response = moyaError.response {

				let responseData = String(data: response.data, encoding: .utf8) ?? "No Response data"
				let wI = NSMutableString(string: responseData)
				CFStringTransform( wI, nil, "Any-Hex/Java" as NSString, true)
			
				let message = """
				||| [ Status Code: \(response.statusCode) ]
				||| [ Method: \(response.request?.httpMethod ?? "Method is unknown")]
				||| [ URL: \(response.request?.url?.description ?? "Path is unknown")]
				"""
				print(entry("Response", message))
				print("Response data: ", wI )
				
			}

			parseError(moyaError)
		}
	}
		
}

func plugins() -> [Moya.PluginType] {
	if let token = AppSettings.token {
		let authPlugin = AccessTokenPlugin { _ in token }
		return [authPlugin]
	} else {
		return []
	}
}

let multiProvider = MoyaProvider<MultiTarget>(plugins: plugins())

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
