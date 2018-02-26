//
//  ApiError.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation


/// Errors that can by thrown by PC2Paper framework
public enum ApiError: Error, CustomStringConvertible, CustomDebugStringConvertible {
	
	/// Unexpected error, should be reported as framework's bug
	case unexpectedError
	
	/// Reponse is not JSON/HTTP etc
	case incorrectResponse
	
	/// Unable to parse JSON reply from API
	case parseFailed(error: Error)
	
	/// Used when request was successfull, but API returned errors
	case error(descriptions: [String])
	
	// MARK: - Variables
	
	/// Alias of `description`
	public var localizedDescription: String { return self.description }
	
	/// Short description of error without any detailed information
	public var description: String {
		switch self {
		case .unexpectedError: return "Unexpected error"
		case .incorrectResponse: return "Incorrect API Response"
		case .parseFailed: return "Failed to parse API response"
		case .error(let descriptions): return descriptions.joined(separator: "\n")
		}
	}
	
	/// Full error's description, may disclose private data
	public var debugDescription: String {
		switch self {
		case .unexpectedError: return "Unexpected error, should be reported as framework's bug"
		case .incorrectResponse: return description
		case .parseFailed(let error): return "Failed to parse API response: \(String(describing: error))"
		case .error(let descriptions):
			let output = "API returned errors: " + descriptions.joined(separator: ", ")
			return output
		}
	}

}

/// Textual error
public struct TextError: Error {
	
	public var localizedDescription: String
	
	init(_ text: String) {
		self.localizedDescription = text
	}
	
}
