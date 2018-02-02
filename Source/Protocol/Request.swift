//
//  Request.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public protocol Request {
	associatedtype AnswerModel: LetterAPIAnswer
	associatedtype BodyModel: RequestBody
	
	var httpMethod: HTTPMethod { get }
	var requestString: String { get }
	
	var body: BodyModel? { get }
}

public protocol RequestBody: Encodable { }
