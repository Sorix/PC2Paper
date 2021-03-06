//
//  PricingAPIOperation.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 09/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Asynchronous operation with request to PC2Paper's Pricing API. You can use operation directly or through calling `PricingAPI.make(...)` closure.
public class PricingAPIOperation<RequestModel: PricingAPIRequest>: AsynchronousOperation {
	
	public typealias FetchResult = Result<RequestModel.AnswerModel>
	
	public let request: RequestModel
	
	/// Requests made through `URLSession`, you can specify session configuration here if you want (e.g. for background operations).
	public var sessionConfig = URLSessionConfiguration.default
	
	/// The block to execute after the operation is completed.
	public var fetchCompletionBlock: ((FetchResult) -> Void)?
	
	/// Operation's result, `nil` if operation is still not completed
	public private(set) var fetchResult: FetchResult?
	
	private let endpoint = "https://www.pc2paper.co.uk/"
	
	/// Initialize Letter API operation.
	///
	/// - Parameter request: `PricingAPIRequest`
	public init(request: RequestModel) {
		self.request = request
	}
	
	/// Performs the receiver’s asynchronous task.
	override public func main() {
		super.main()
		
		guard let internalRequest = request as? _PricingAPIRequest else {
			finish(result: .failed(ApiError.unexpectedError))
			return
		}
		
		// Make URL Request
		let urlString = endpoint + internalRequest.requestString
		//		print(urlString)
		guard let url = URL(string: urlString) else {
			finish(result: .failed(ApiError.unexpectedError))
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		
		// Start session
		let session = URLSession(configuration: sessionConfig)
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			// HTTP Errors
			if let error = error {
				self.finish(result: .failed(error))
				return
			}
			
			guard let response = response as? HTTPURLResponse,
				let data = data, response.statusCode == 200 else {
					self.finish(result: .failed(ApiError.incorrectResponse))
					return
			}
			
			// Get access to internal answer protocol
			guard let internalAnswer = RequestModel.AnswerModel.self as? _PricingAPIAnswer.Type else {
				self.finish(result: .failed(ApiError.unexpectedError))
				return
			}
			
			// Correct answer
			do {
				guard let answer = try internalAnswer.init(from: data) as? RequestModel.AnswerModel else {
					self.finish(result: .failed(ApiError.unexpectedError))
					return
				}
				
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
	
}
