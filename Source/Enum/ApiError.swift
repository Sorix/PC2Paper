//
//  ApiError.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public enum ApiError: Error, CustomStringConvertible, CustomDebugStringConvertible {
	
	/// Reponse is not JSON/HTTP etc
	case incorrectResponse
	
	/// Unable to parse JSON reply from API
	case parseFailed(error: Error)
	
	/// Used when API returns errors
	case error(descriptions: [String])
	
	public var localizedDescription: String { return self.description }
	
	public var description: String {
		switch self {
		case .incorrectResponse: return "Incorrect API Response"
		case .parseFailed: return "Failed to parse API response"
		case .error: return "API returned some errors"
		}
	}
	
	public var debugDescription: String {
		switch self {
		case .incorrectResponse: return description
		case .parseFailed(let error): return "Failed to parse API response: \(error)"
		case .error(let descriptions):
			let output = "API returned errors: " + descriptions.joined(separator: ", ")
			return output
		}
	}
	

}
