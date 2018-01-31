//
//  SendSubmitLetterForPosting.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//
// API Example: http://www.pc2paper.org/PermaLink,guid,0e1b08fd-56af-409d-bd30-6b66bb6a0c00.aspx

import Foundation

public struct SendSubmitLetterForPostingRequest: Request {
	
	public typealias AnswerModel = SendSubmitLetterForPostingAnswer
	public typealias BodyModel = SendSubmitLetterForPostingRequestBody
	
	public let httpMethod: HTTPMethod = .POST
	public let requestString = "SendSubmitLetterForPosting"
	
	public var body: BodyModel?
	
	public init(body: SendSubmitLetterForPostingRequestBody) {
		self.body = body
	}
	
}

public struct SendSubmitLetterForPostingRequestBody: RequestBody {
	
	public struct Letter: Encodable {
		
		public struct Address: Encodable {
			var name, addressLine1, addressLine2, townCity, postCode: String?
		}
		
		public struct Sender: Encodable {
			var address: String
			
			/// This tells the site that you wish to have this placed on the enevelope
			var includeSenderAddressOnEnvelope: Bool = false
		}
		
		/// This is the name of your application so we can identify it if PC2Paper find any problems
		var sourceClient: String
		
		/// This is an array of addresses you would like to send the letter to
		var addresses: [Address]
		
		var receiverCountryCode: Int
		
		/// This is the postage zone you would like your letter to be sent from, such as UK first class or UK second class.
		var postage: Int
		
		/// This is the Paper type you would like your letter printed on.
		var paper: Int
		
		/// The envelope your letter is to be sent in.
		var envelope: Int
		
		/// This is for extras such as Recorded Mail.
		var extras: Int
		
		/// This is where you can write your letter. It can be formated HTMl or left blank if you would rather just attach a PDF to your letter. You can also have both options at once.
		var letterBody: String?
		
		/// This is your own reference number that be used for your own tracking purposes or admin. Perhaps from you rown CRM system.
		var yourRef: String?
		
	}

	var letterForPosting: Letter
	var username: String
	var password: String

}

public struct SendSubmitLetterForPostingAnswer: Answer {
	
}
