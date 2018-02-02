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
	
	var requestString: String {
		return "datagetpostage.asp?method=getZoneOffers&str=" + String(zoneID) }
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Creates an instance of request
	///
	/// - Parameter zoneID: Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public init(zoneID: Int) {
		self.zoneID = zoneID
	}
	
}

/// Answer for `ZoneOffersRequest` request. This will return options such as recorded delivery, signed for etc...
public struct ZoneOffersAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Array of offers for that zone
	public let offers: [Offer]
	
	// MARK: - Models
	
	/// PC2Paper represents each postage option as a Zone.
	public struct Offer {
		
		/// Zone ID, store it for future API calls
		public let itemID: Int
		
		/// Example: `Special Next Day Delivery before 1pm`
		public let name: String
		
	}
	
	init(from data: Data) throws {
		let xml = SWXMLHash.parse(data)
		
		let xmlZones = try xml.byKey("PrintType")
		let xmlNames = try xmlZones.byKey("name")
		
		var offers = [Offer]()
		for xmlName in xmlNames.all {
			guard let itemIDText = xmlName.element?.attribute(by: "itemID")?.text,
				let itemID = Int(itemIDText),
				let name = xmlName.element?.text else {
					let textError = ApiError.error(descriptions: ["Zoneid element is incorrect"])
					throw ApiError.parseFailed(error: textError)
			}
			
			let newOffer = Offer(itemID: itemID, name: name)
			offers.append(newOffer)
		}
		
		self.offers = offers
	}
	
}

