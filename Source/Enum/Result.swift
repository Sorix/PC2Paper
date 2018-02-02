//
//  Result.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Results are wrapped to that enumeration, so you can eliminate unneeded optionals
public enum Result<T> {
	
	/// Request was succeded and we have answer in it
	case succeed(T)
	
	/// Request was failed, check corresponding error
	case failed(Error)
	
}
