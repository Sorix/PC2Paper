//
//  Body.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public struct SendSubmitLetterForPostingRequestBody: RequestBody {
	
	public struct Letter: Encodable {
		
		public struct Address: Encodable {
			public var name, addressLine1, addressLine2, townCity, postCode: String?
			public init() { }
		}
		
		public struct Sender: Encodable {
			
			/// This is your return address. Each line can be seperated by a line break.
			public var address: String
			
			/// This tells the site that you wish to have this placed on the enevelope
			public var includeSenderAddressOnEnvelope: Bool = false
			
			public init(address: String) {
				self.address = address
			}
			
		}
		
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
		
		/// This is your own reference number that be used for your own tracking purposes or admin. Perhaps from you rown CRM system.
		public var yourRef: String?
		
		/// If you have uploaded your PDF files, you will be provided with a FileCreatedGUID for each file you upload, attach it here
		public var fileAttachementGUIDs: [String]?
		
	}
	
	public var letterForPosting: Letter
	public var username: String
	public var password: String
	
	public init(letter: Letter, username: String, password: String) {
		self.letterForPosting = letter
		self.username = username
		self.password = password
	}
	
}


// Letter initializer
extension SendSubmitLetterForPostingRequestBody.Letter {
	
	/// Description of fields you can find at `SendSubmitLetterForPostingRequestBody.Letter` struct
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
