//
//  TotalLetterCost.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 03/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation
import SWXMLHash

/// This request asks to calculate the total cost of the letter given the results of the previous API methods.
public struct TotalLetterCostRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = TotalLetterCostAnswer
	
	var requestString: String { return "datagetpostage.asp?method=getServiceChargeBasedOnZone&str=" + String(zoneID) }
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Paper type ID received from `PaperTypeAnswer.Paper.id` answer
	public var paperTypeID: Int
	
	/// Number of pages in your letter
	public var numberOfPages: Int
	
	/// Zone offer ID received from `ZoneOffersAnswer.Offer.id`
	public var zoneOfferID: Int
	
	/// Envelope type ID received from `EnvelopesAvailableAnswer.EnvelopeType.id`
	public var envelopeID: Int
	
	/// Creates an instance of request
	public init(zoneID: Int, paperTypeID: Int, numberOfPages: Int, zoneOfferID: Int, envelopeID: Int) {
		self.zoneID = zoneID
		self.paperTypeID = paperTypeID
		self.numberOfPages = numberOfPages
		self.zoneOfferID = zoneOfferID
		self.envelopeID = envelopeID
	}
	
}

/// Answer for `EnvelopesAvailableRequest` request. This will return envelopes available for this particular zone, such as `Standard DL` or `A4 White Envelope`
public struct TotalLetterCostAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Array of offers for that zone
	public let envelopes: [Envelope]
	
	// MARK: - Models
	
	/// PC2Paper represents each postage option as a Zone.
	public struct Envelope {
		
		/// Envelope ID
		public let id: Int
		
		/// Cost of envelope
		public let cost: Double
		
		/// Envelope name, e.g. `c. A4 White Envelope`
		public let name: String
		
	}
	
	init(from data: Data) throws {
		let xml = SWXMLHash.parse(data)
		let xmlNames = try xml.byKey("PrintType").byKey("name")
		
		var envelopes = [Envelope]()
		for xmlName in xmlNames.all {
			let envelope = try Envelope(id: xmlName.value(ofAttribute: "itemID"),
										cost: xmlName.value(ofAttribute: "cost"),
										name: xmlName.value())
			
			envelopes.append(envelope)
		}
		
		self.envelopes = envelopes
	}
	
}

