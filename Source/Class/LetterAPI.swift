//
//  PC2Paper.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class LetterAPI {
	
	private let endpoint = URL(string: "https://www.pc2paper.co.uk/lettercustomerapi.svc/json/")!
	
	public init() {}
	
	public func make<RequestModel: LetterAPIRequest>(request: RequestModel, sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default, completion: @escaping (Result<RequestModel.AnswerModel>) -> Void) {
		
		guard let internalRequest = request as? _LetterAPIRequest else {
			completion(.failed(ApiError.unexpectedError)); return
		}
		
		// Make URL Request
		let url = endpoint.appendingPathComponent(internalRequest.requestString)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = internalRequest.httpMethod.rawValue
		
		// Request body
		if let body = request.body {
			do {
				let bodyJson = try JSONEncoder().encode(body)
				urlRequest.httpBody = bodyJson
				urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
			} catch {
				completion(.failed(error))
				return
			}
		}
		
		// Start session
		let session = URLSession(configuration: sessionConfig)
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			// HTTP Errors
			if let error = error {
				completion(.failed(error))
				return
			}
			
			guard let data = data else {
					completion(.failed(ApiError.incorrectResponse))
					return
			}
			
			// Custom API errors
			if let status = try? JSONDecoder().decode(StatusAnswer.self, from: data).status, status == "Error" {
				let parsedError = self.parseError(data: data)
				completion(.failed(parsedError))
				return
			}
			
			// Correct answer
			do {
				let answer = try JSONDecoder().decode(RequestModel.AnswerModel.self, from: data)
				completion(.succeed(answer))
			} catch {
				let parseError = ApiError.parseFailed(error: error)
				completion(.failed(parseError))
			}
		}
		
		task.resume()
	}
	
	func parseError(data: Data) -> ApiError {
		var descriptions = [String]()
		if let errorAnswer = try? JSONDecoder().decode(ErrorAnswer.self, from: data) {
			descriptions = errorAnswer.errorMessages
		}
		
		return ApiError.error(descriptions: descriptions)
	}
	
}
