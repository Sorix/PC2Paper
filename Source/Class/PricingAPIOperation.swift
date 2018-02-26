//
//  PricingAPIOperation.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 09/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class PricingAPIOperation<RequestModel: PricingAPIRequest>: AsynchronousOperation {
	
	public let request: RequestModel
	
	public var sessionConfig = URLSessionConfiguration.default
	public var fetchCompletionBlock: ((Result<RequestModel.AnswerModel>) -> Void)?
	
	private let endpoint = "https://www.pc2paper.co.uk/"
	
	public init(request: RequestModel) {
		self.request = request
	}
	
	override public func main() {
		super.main()
		
		guard let internalRequest = request as? _PricingAPIRequest else {
			fetchCompletionBlock?(.failed(ApiError.unexpectedError))
			state = .finished
			return
		}
		
		// Make URL Request
		let urlString = endpoint + internalRequest.requestString
		print(urlString)
		guard let url = URL(string: urlString) else {
			fetchCompletionBlock?(.failed(ApiError.unexpectedError))
			state = .finished
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		
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
			
			guard let response = response as? HTTPURLResponse,
				let data = data, response.statusCode == 200 else {
					self.fetchCompletionBlock?(.failed(ApiError.incorrectResponse))
					return
			}
			
			// Get access to internal answer protocol
			guard let internalAnswer = RequestModel.AnswerModel.self as? _PricingAPIAnswer.Type else {
				self.fetchCompletionBlock?(.failed(ApiError.unexpectedError))
				return
			}
			
			// Correct answer
			do {
				guard let answer = try internalAnswer.init(from: data) as? RequestModel.AnswerModel else {
					self.fetchCompletionBlock?(.failed(ApiError.unexpectedError))
					return
				}
				
				self.fetchCompletionBlock?(.succeed(answer))
			} catch {
				let parseError = ApiError.parseFailed(error: error)
				self.fetchCompletionBlock?(.failed(parseError))
			}
		}
		
		task.resume()
	}
	
}