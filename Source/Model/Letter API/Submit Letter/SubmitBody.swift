//
//  Body.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Body with letter information
public class SubmitLetterForPostingRequestBody: RequestBody {

	public var letterForPosting: Letter
	
	/// Your PC2Paper username
	public var username: String
	
	/// Your PC2Paper password
	public var password: String
	
	// MARK: Initializing an Item
	
	public init(letter: Letter, username: String, password: String) {
		self.letterForPosting = letter
		self.username = username
		self.password = password
	}
	
}

extension SubmitLetterForPostingRequestBody {
	
	// MARK: - Models
	
	/// Letter body
	public class Letter: Encodable {
		
		/// This is the name of your application so we can identify it if PC2Paper find any problems
		public var sourceClient: String
		
		/// This is an array of addresses you would like to send the letter to
		public var addresses: [Address]
		
		public var receiverCountryCode: Int
		
		/// This is the postage zone you would like your letter to be sent from, such as UK first class or UK second class.
		public var postage: Int
		
		/// This is the Paper type you would like your letter printed on.
		public var paper: Int
		
		/// The envelope your letter is to be sent in.
		public var envelope: Int
		
		/// This is for extras such as Recorded Mail.
		public var extras: Int
		
		/// This is where you can write your letter. It can be formated HTMl or left blank if you would rather just attach a PDF to your letter. You can also have both options at once.
		public var letterBody: String?
		
		/// Look at `Sender` object
		public var sender: Sender?
		
		/// This is your own reference number that be used for your own tracking purposes or admin. Perhaps from you rown CRM system.
		public var yourRef: String?
		
		/// If you have uploaded your PDF files, you will be provided with a `UploadDocumentRequest` for each file you upload, attach it here
		public var fileAttachementGUIDs: [String]?
	
		// MARK: Initializing an Item
		
		public init(sourceClient: String, addresses: [Address], receiverCountryCode: Int, postage: Int, paper: Int, envelope: Int, extras: Int) {
			self.sourceClient = sourceClient
			self.addresses = addresses
			self.receiverCountryCode = receiverCountryCode
			self.postage = postage
			self.paper = paper
			self.envelope = envelope
			self.extras = extras
		}
		
	}
	
}

extension SubmitLetterForPostingRequestBody.Letter {

	// MARK: Models
	
	public class Address: Encodable {
		
		enum CodingKeys: String, CodingKey {
			case name = "ReceiverName"
			case addressLine1 = "ReceiverAddressLine1"
			case addressLine2 = "ReceiverAddressLine2"
			case townCity = "ReceiverAddressTownCityOrLine3"
			case postCode = "ReceiverAddressPostCode"
		}
		
		public var name: String?
		public var addressLine1: String?
		public var addressLine2: String?
		public var townCity: String?
		public var postCode: String?
		
		// MARK: Initializing an Item
		
		public init() { }
	}
	
	public class Sender {
		
		/// This is your return address. Each line can be seperated by a line break.
		public var address: String
		
		/// This tells the site that you wish to have this placed on the enevelope
		public var includeSenderAddressOnEnvelope: Bool = false
		
		public init(address: String) {
			self.address = address
		}
		
	}
	
}

// Letter Encodable

extension SubmitLetterForPostingRequestBody.Letter {
	
	// MARK: Encodable
	
	enum CodingKeys: String, CodingKey {
		case sourceClient = "SourceClient"
		case addresses = "Addresses"
		case receiverCountryCode = "ReceiverCountryCode"
		case postage = "Postage"
		case paper = "Paper"
		case envelope = "Envelope"
		case extras = "Extras"
		case letterBody = "LetterBody"
		case yourRef = "YourRef"
		case fileAttachementGUIDs = "FileAttachementGUIDs"
		
		case senderAddress = "SenderAddress"
		case includeSenderAddressOnEnvelope = "IncludeSenderAddressOnEnvelope"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(sourceClient, forKey: .sourceClient)
		try container.encode(addresses, forKey: .addresses)
		try container.encode(receiverCountryCode, forKey: .receiverCountryCode)
		try container.encode(postage, forKey: .postage)
		try container.encode(paper, forKey: .paper)
		try container.encode(envelope, forKey: .envelope)
		try container.encode(extras, forKey: .extras)
		try container.encode(letterBody, forKey: .letterBody)
		try container.encode(yourRef, forKey: .yourRef)
		try container.encode(fileAttachementGUIDs, forKey: .fileAttachementGUIDs)
		
		try container.encodeIfPresent(sender?.address, forKey: .senderAddress)
		try container.encodeIfPresent(sender?.includeSenderAddressOnEnvelope, forKey: .includeSenderAddressOnEnvelope)
	}
	
}
