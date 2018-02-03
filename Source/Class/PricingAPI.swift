//
//  PricingAPI.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class PricingAPI {
	
	private let endpoint = "https://www.pc2paper.co.uk/"
	
	public init() {}
	
	public func make<RequestModel: PricingAPIRequest>(request: RequestModel, sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default, completion: @escaping (Result<RequestModel.AnswerModel>) -> Void) {
		
		guard let internalRequest = request as? _PricingAPIRequest else {
			completion(.failed(ApiError.unexpectedError)); return
		}
		
		// Make URL Request
		let urlString = endpoint + internalRequest.requestString
		print(urlString)
		guard let url = URL(string: urlString) else {
			completion(.failed(ApiError.unexpectedError)); return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		
		// Start session
		let session = URLSession(configuration: sessionConfig)
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			// HTTP Errors
			if let error = error {
				completion(.failed(error))
				return
			}
			
			guard let response = response as? HTTPURLResponse,
				let data = data, response.statusCode == 200 else {
					completion(.failed(ApiError.incorrectResponse))
					return
			}
			
			// Get access to internal answer protocol
			guard let internalAnswer = RequestModel.AnswerModel.self as? _PricingAPIAnswer.Type else {
				completion(.failed(ApiError.unexpectedError))
				return
			}

			// Correct answer
			do {
				print("RAW Answer: \(String(data: data, encoding: .utf8))")
				guard let answer = try internalAnswer.init(from: data) as? RequestModel.AnswerModel else {
					completion(.failed(ApiError.unexpectedError))
					return
				}
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
