//
//  ZonesLetterCanBeSentFrom.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public struct ZonesLetterCanBeSentFrom: Request {
	
	public typealias AnswerModel = UploadDocumentAnswer
	public typealias BodyModel = UploadDocumentRequestBody
	
	public let httpMethod: HTTPMethod = .POST
	public var requestString: String {
		return "datagetpostage.asp?method=getZonesLetterCanBeSentFrom&str=" + String(countryCode) }
	
	public let body: BodyModel? = nil
	
	public var countryCode: Int
	
	public init(countryCode: Int) {
		self.countryCode = countryCode
	}
	
}
