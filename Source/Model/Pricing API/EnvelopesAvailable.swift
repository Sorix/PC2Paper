//
//  EnvelopesAvailable.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 03/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation
import SWXMLHash

/// This request asks for a list of envelopes available for this particular zone.
public struct EnvelopesAvailableRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = EnvelopesAvailableAnswer
	
	var requestString: String { return "datagetpostage.asp?method=getEnvelopesPerZone&str=" + String(zoneID) }
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Creates an instance of request
	///
	/// - Parameter zoneID: Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public init(zoneID: Int) {
		self.zoneID = zoneID
	}
	
}

/// Answer for `EnvelopesAvailableRequest` request. This will return envelopes available for this particular zone, such as `Standard DL` or `A4 White Envelope`
public struct EnvelopesAvailableAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
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

