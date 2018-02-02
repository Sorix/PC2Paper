//
//  LetterAPIRequest.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public protocol LetterAPIRequest {
	associatedtype AnswerModel: LetterAPIAnswer
	associatedtype BodyModel: RequestBody
	
	var body: BodyModel? { get }
}

internal protocol _LetterAPIRequest {
	var httpMethod: HTTPMethod { get }
	var requestString: String { get }
}

public protocol RequestBody: Encodable { }
