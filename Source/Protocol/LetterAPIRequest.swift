//
//  LetterAPIRequest.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// All requests to Letter API have to adopt that protocol
public protocol LetterAPIRequest {
	
	/// Answer for request will be in that type
	associatedtype AnswerModel: LetterAPIAnswer
	
	/// Request's JSON body type
	associatedtype BodyModel: RequestBody
	
	/// Request's JSON body
	var body: BodyModel? { get }
	
}

internal protocol _LetterAPIRequest {
	var httpMethod: HTTPMethod { get }
	var requestString: String { get }
}

public protocol RequestBody: Encodable { }
