//
//  SendSubmitLetterForPosting.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//
// API Example: http://www.pc2paper.org/PermaLink,guid,0e1b08fd-56af-409d-bd30-6b66bb6a0c00.aspx

import Foundation

/// Send letter request
public struct SubmitLetterForPostingRequest: LetterAPIRequest, _LetterAPIRequest {
	
	public typealias AnswerModel = SubmitLetterForPostingAnswer
	public typealias BodyModel = SubmitLetterForPostingRequestBody
	
	let httpMethod: HTTPMethod = .POST
	let requestString = "SendSubmitLetterForPosting"
	
	public var body: BodyModel?
	
	public init(body: SubmitLetterForPostingRequestBody) {
		self.body = body
	}
	
}
