//
//  UploadDocumentRequest.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public struct UploadDocumentRequest: Request {
	
	public typealias AnswerModel = UploadDocumentAnswer
	public typealias BodyModel = UploadDocumentRequestBody
	
	public let httpMethod: HTTPMethod = .POST
	public let requestString = "UploadDocument"
	
	public var body: BodyModel?
	
	public init(body: UploadDocumentRequestBody) {
		self.body = body
	}
	
}

public struct UploadDocumentRequestBody: RequestBody {
	
	var filename: String
	var username, password: String
	var fileData: Data
	
	public init(filename: String, fileData: Data, username: String, password: String) {
		self.filename = filename
		self.fileData = fileData
		self.username = username
		self.password = password
	}
	
	// MARK: Encodable
	
	enum CodingKeys: String, CodingKey {
		case filename, username, password
		case fileData = "fileContent"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(filename, forKey: .filename)
		try container.encode(username, forKey: .username)
		try container.encode(password, forKey: .password)

		let byteArray = [UInt8](fileData)
		try container.encode(byteArray, forKey: .fileData)
	}
	
	
}

public struct UploadDocumentAnswer: Answer {
	
	let errorMessages: [String]?
	let fileCreatedGUID: String?
	let status: String
	let pages: Int?
	
	// MARK: Decodable
	
	private enum CodingKeys: String, CodingKey {
		case errorMessages = "ErrorMessages"
		case fileCreatedGUID = "FileCreatedGUID"
		case status = "Status"
		case pages = "Pages"
	}
	
	private enum RootCodingKey: String, CodingKey {
		case root = "d"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RootCodingKey.self)
		let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .root)
		
		errorMessages = try nestedContainer.decodeIfPresent([String].self, forKey: .errorMessages)
		fileCreatedGUID = try nestedContainer.decodeIfPresent(String.self, forKey: .fileCreatedGUID)
		status = try nestedContainer.decode(String.self, forKey: .status)
		pages = try nestedContainer.decode(Int.self, forKey: .pages)
	}
	
}
