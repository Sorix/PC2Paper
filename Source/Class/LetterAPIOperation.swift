//
//  LetterAPIOperation.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 26/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class LetterAPIOperation<RequestModel: LetterAPIRequest>: AsynchronousOperation {
	
	public typealias FetchResult = Result<RequestModel.AnswerModel>
	
	public let request: RequestModel
	
	public var sessionConfig = URLSessionConfiguration.default
	public var fetchCompletionBlock: ((FetchResult) -> Void)?
	
	public private(set) var fetchResult: FetchResult?
	
	private let endpoint = "https://www.pc2paper.co.uk/lettercustomerapi.svc/json/"
	
	public init(request: RequestModel) {
		self.request = request
	}
	
	override public func main() {
		super.main()
		
		guard let internalRequest = request as? _LetterAPIRequest else {
			self.finish(result: .failed(ApiError.unexpectedError))
			return
		}
		
		// Make URL Request
		let urlString = endpoint + internalRequest.requestString
		print(urlString)
		guard let url = URL(string: urlString) else {
			self.finish(result: .failed(ApiError.unexpectedError))
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
				self.finish(result: .failed(error))
				return
			}
		}
		
		// Start session
		let session = URLSession(configuration: sessionConfig)
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			// HTTP Errors
			if let error = error {
				self.finish(result: .failed(error))
				return
			}
			
			guard let data = data else {
				self.finish(result: .failed(ApiError.incorrectResponse))
				return
			}
			
			// Custom API errors
			if let status = try? JSONDecoder().decode(StatusAnswer.self, from: data).status, status == "Error" {
				let parsedError = self.parseError(data: data)
				self.finish(result: .failed(parsedError))
				return
			}
			
			// Correct answer
			do {
				let answer = try JSONDecoder().decode(RequestModel.AnswerModel.self, from: data)
				self.finish(result: .succeed(answer))
			} catch {
				let parseError = ApiError.parseFailed(error: error)
				self.finish(result: .failed(parseError))
			}
		}
		
		task.resume()
	}
	
	private func finish(result: FetchResult) {
		fetchResult = result
		fetchCompletionBlock?(result)
		state = .finished
	}
	
	private func parseError(data: Data) -> ApiError {
		var descriptions = [String]()
		if let errorAnswer = try? JSONDecoder().decode(ErrorAnswer.self, from: data) {
			descriptions = errorAnswer.errorMessages
		}
		
		return ApiError.error(descriptions: descriptions)
	}
	
}
