//
//  PC2Paper.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class PC2Paper {
	
	private let endpoint = URL(string: "https://www.pc2paper.co.uk/lettercustomerapi.svc/json/")!
	
	public func make<RequestModel: Request>(request: RequestModel, sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default, completion: @escaping (_ answer: RequestModel.AnswerModel?, _ error: Error?) -> Void) {
		
		// Make URL Request
		let url = endpoint.appendingPathComponent(request.requestString)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.httpMethod.rawValue
		
		if let body = request.body {
			do {
				let bodyJson = try JSONEncoder().encode(body)
				urlRequest.httpBody = bodyJson
				urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
			} catch {
				completion(nil, error)
				return
			}
		}
		
		// Start session
		let session = URLSession(configuration: sessionConfig)
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			// HTTP Errors
			if let error = error {
				completion(nil, error)
				return
			}
			
			guard let response = response as? HTTPURLResponse,
				let data = data else {
					completion(nil, ApiError.incorrectResponse)
					return
			}
			
			// Custom API errors
			if response.statusCode != 200 {
				let parsedError = self.parseError(code: response.statusCode, data: data)
				completion(nil, parsedError)
				return
			}
			
			// Correct answer
			do {
				let answer = try JSONDecoder().decode(RequestModel.AnswerModel.self, from: data)
				completion(answer, nil)
			} catch {
				completion(nil, ApiError.parseFailed(error: error))
			}
		}
		
		task.resume()
	}
	
	func parseError(code: Int, data: Data) -> ApiError {
		return ApiError.error(code: code, description: String(data: data, encoding: .utf8))
	}
	
}
