//
//  ApiError.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public enum ApiError: Error, CustomStringConvertible, CustomDebugStringConvertible {
	case incorrectResponse
	case parseFailed(error: Error)
	case error(code: Int, description: String?)
	
	public var localizedDescription: String { return self.description }
	
	public var description: String {
		switch self {
		case .incorrectResponse: return "Incorrect API Response"
		case .parseFailed: return "Failed to parse API response"
		case .error(let code): return "API error \(code)"
		}
	}
	
	public var debugDescription: String {
		switch self {
		case .incorrectResponse: return description
		case .parseFailed(let error): return "Failed to parse API response: \(error)"
		case .error(let code, let description):
			var output = "API error \(code)"
			if let description = description {
				output += ": \(description)"
			}
			return output
		}
	}
	

}
