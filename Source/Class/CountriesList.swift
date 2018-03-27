//
//  FetchCountries.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 06/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Class that can be used to fetch list of possible destination and origin countries with ID and names.
public class CountriesList {

	private static let endpoint = URL(string: "https://www.pc2paper.co.uk/downloads/country.csv")!

	/// Fetch list of countries.
	///
	/// - Parameters:
	///   - sessionConfig: request made through `URLSession`, you can specify session configuration here if you want (e.g. for background operations).
	public static func fetch(sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default, completion: @escaping (Result<CountriesAnswer>) -> Void) {
		
		var urlRequest = URLRequest(url: endpoint)
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
			
			// Correct answer
			do {
				let answer = try CountriesAnswer(from: data)
				completion(.succeed(answer))
			} catch {
				let parseError = ApiError.parseFailed(error: error)
				completion(.failed(parseError))
			}
		}
		
		task.resume()
	}
	
}
