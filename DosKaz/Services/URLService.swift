//
//  URLService.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/1/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework
import Moya

protocol URLService {
	associatedtype CodableRoot: Codable
	associatedtype CustomError: Error
	
	var onSuccess: CommandWith<CodableRoot> { get }
	var onFailure: CommandWith<CustomError> { get }
	
	func parseData(_ data: Data)
	func parseError(_ moyaError: Error)
}

extension URLService {
	
	func parseData(_ data: Data) {
		guard !data.isEmpty else { return }
		do {
			let rootObject = try JSONDecoder().decode(CodableRoot.self , from: data)
			onSuccess.perform(with: rootObject)
		} catch {
			print("Data can't be parsed into json")
			return
		}
	}
	
	func parseError(_ moyaError: Error) {
		switch (moyaError is CustomError) {
		case true:
			let moyaError = moyaError as! CustomError
			onFailure.perform(with: moyaError)
		case false:
			break
			
		}
	}

	private func dataTaskCompletionHandler(data:Data?, urlResponse: URLResponse?, error: Error?) -> Void {
		// Add validation
		DispatchQueue.main.async {
			let moyaResult = convertResponseToResult(urlResponse as? HTTPURLResponse, request: nil, data: data, error: error)
			switch moyaResult {
			case let .success(response):
				self.parseData(response.data)
			case let .failure(moyaError):
				self.parseError(moyaError)
			}
		}
	}
	
}

extension URLService  where Self: TargetType {
	
	
	func resumeDataTask() {
		guard let request = urlRequest() else { return }
		let task = URLSession.shared.dataTask(with: request, completionHandler: dataTaskCompletionHandler)
		task.resume()
	}
	
	private func urlRequest() -> URLRequest? {
		let target = self
		let endpoint = Endpoint(
			url: URL(target: target).absoluteString,
			sampleResponseClosure: { .networkResponse(200, target.sampleData) },
			method: target.method,
			task: target.task,
			httpHeaderFields: target.headers
		)
		
		do {
			let urlRequest = try endpoint.urlRequest()
			return urlRequest
		} catch {
			return nil
		}
	}
	
}

// MARK: - Swapi Example

protocol SwapiService: URLService, TargetType { }

extension SwapiService {
		var baseURL: URL { return URL(string:"https://swapi.co/api/")! }
}

struct Person: SwapiService {
	
	var onSuccess: Character.Command = .nop
	
	var onFailure: CommandWith<Error> = .nop
	
	var path: String { return "people/2"}
		
}


struct Character: Codable {
	typealias Command = CommandWith<Character>
	
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


//MARK: Experiment

public typealias I = (response: HTTPURLResponse?, request: URLRequest?, data: Data?, error: Swift.Error?)
public typealias MoyaResult = Result<Moya.Response, MoyaError>

public func convertResponseToResult(_ args: I) -> MoyaResult {
	switch (args.response, args.data, args.error) {
		case let (.some(response), data, .none):
			let response = Moya.Response(statusCode: response.statusCode, data: data ?? Data(), request: args.request, response: response)
			return .success(response)
		case let (.some(response), _, .some(error)):
			let response = Moya.Response(statusCode: response.statusCode, data: args.data ?? Data(), request: args.request, response: response)
			let error = MoyaError.underlying(error, response)
			return .failure(error)
		case let (_, _, .some(error)):
			let error = MoyaError.underlying(error, nil)
			return .failure(error)
		default:
			let error = MoyaError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil), nil)
			return .failure(error)
		}
}
