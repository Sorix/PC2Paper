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
	
	public func make<RequestModel: Request>(request: RequestModel, sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default, completion: @escaping (Result<RequestModel.AnswerModel>) -> Void) {
		
		// Make URL Request
		let url = endpoint.appendingPathComponent(request.requestString)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.httpMethod.rawValue
		
		if let body = request.body {
			do {
				let bodyJson = try JSONEncoder().encode(body)
				
				// Debug
				let encoder = JSONEncoder()
				encoder.outputFormatting = .prettyPrinted
				let prettyBody = try encoder.encode(body)
				print("JSON Request")
				print(String(data: prettyBody, encoding: .utf8))
				// End of debug
				
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
			
			guard let response = response as? HTTPURLResponse,
				let data = data else {
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
				print("RAW Answer: \(String(data: data, encoding: .utf8))")
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
