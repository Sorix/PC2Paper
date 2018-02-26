//
//  LetterAPIOperation.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 26/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class LetterAPIOperation<RequestModel: LetterAPIRequest>: AsynchronousOperation {
	
	public let request: RequestModel
	
	public var sessionConfig = URLSessionConfiguration.default
	public var fetchCompletionBlock: ((Result<RequestModel.AnswerModel>) -> Void)?
	
	private let endpoint = "https://www.pc2paper.co.uk/lettercustomerapi.svc/json/"
	
	public init(request: RequestModel) {
		self.request = request
	}
	
	override public func main() {
		super.main()
		
		guard let internalRequest = request as? _LetterAPIRequest else {
			fetchCompletionBlock?(.failed(ApiError.unexpectedError))
			state = .finished
			return
		}
		
		// Make URL Request
		let urlString = endpoint + internalRequest.requestString
		print(urlString)
		guard let url = URL(string: endpoint) else {
			fetchCompletionBlock?(.failed(ApiError.unexpectedError))
			state = .finished
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = internalRequest.httpMethod.rawValue
		
		// Request body
		if let body = request.body {
			do {
				let bodyJson = try JSONEncoder().encode(body)
				urlRequest.httpBody = bodyJson
				urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
			} catch {
				fetchCompletionBlock?(.failed(error))
				state = .finished
				return
			}
		}
		
		// Start session
		let session = URLSession(configuration: sessionConfig)
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			defer {
				self.state = .finished
			}
			
			// HTTP Errors
			if let error = error {
				self.fetchCompletionBlock?(.failed(error))
				return
			}
			
			guard let data = data else {
				self.fetchCompletionBlock?(.failed(ApiError.incorrectResponse))
				return
			}
			
			// Custom API errors
			if let status = try? JSONDecoder().decode(StatusAnswer.self, from: data).status, status == "Error" {
				let parsedError = self.parseError(data: data)
				self.fetchCompletionBlock?(.failed(parsedError))
				return
			}
			
			// Correct answer
			do {
				let answer = try JSONDecoder().decode(RequestModel.AnswerModel.self, from: data)
				self.fetchCompletionBlock?(.succeed(answer))
			} catch {
				let parseError = ApiError.parseFailed(error: error)
				self.fetchCompletionBlock?(.failed(parseError))
			}
		}
		
		task.resume()
	}
	
	private func parseError(data: Data) -> ApiError {
		var descriptions = [String]()
		if let errorAnswer = try? JSONDecoder().decode(ErrorAnswer.self, from: data) {
			descriptions = errorAnswer.errorMessages
		}
		
		return ApiError.error(descriptions: descriptions)
	}
	
}
