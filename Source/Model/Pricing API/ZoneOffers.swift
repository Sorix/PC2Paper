//
//  ZoneOffers.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation
import SWXMLHash

/// This request asks for all the "extras" available to a user based on the zone they wish to send their letter from.
public struct ZoneOffersRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = ZoneOffersAnswer
	
	var requestString: String { return "datagetpostage.asp?method=getZoneOffers&str=" + String(zoneID) }
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Creates an instance of request
	///
	/// - Parameter zoneID: Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public init(zoneID: Int) {
		self.zoneID = zoneID
	}
	
}

/// Answer for `ZoneOffersRequest` request. This will return options such as recorded delivery, signed for etc.
public struct ZoneOffersAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Array of offers for that zone
	public let offers: [Offer]
	
	// MARK: - Models
	
	/// PC2Paper represents each postage option as a Zone.
	public struct Offer {
		
		/// Zone ID, store it for future API calls
		public let id: Int
		
		/// Example: `Special Next Day Delivery before 1pm`
		public let name: String
		
	}
	
	init(from data: Data) throws {
		let xml = SWXMLHash.parse(data)
		let xmlNames = try xml.byKey("PrintType").byKey("name")
		
		var offers = [Offer]()
		for xmlName in xmlNames.all {
			let newOffer = try Offer(id: xmlName.value(ofAttribute: "itemID"), name: xmlName.value())
			offers.append(newOffer)
		}
		
		self.offers = offers
	}
	
}

