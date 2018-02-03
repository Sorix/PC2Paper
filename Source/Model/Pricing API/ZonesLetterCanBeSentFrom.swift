//
//  ZonesLetterCanBeSentFrom.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation
import SWXMLHash

public struct ZonesLetterCanBeSentFromRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = ZonesLetterCanBeSentFromAnswer
	
	var requestString: String { return "datagetpostage.asp?method=getZonesLetterCanBeSentFrom&str=" + String(countryCode) }
	
	/// The country code we wish to receive available pricing for
	public var countryCode: Int
	
	public init(countryCode: Int) {
		self.countryCode = countryCode
	}
	
}

public struct ZonesLetterCanBeSentFromAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Array of zones for that country
	public let zones: [Zone]
	
	// MARK: - Models
	
	/// PC2Paper represents each postage option as a Zone.
	public struct Zone {
		
		/// Zone ID, store it for future API calls
		public let id: Int
		
		/// Example: `UK Signed For 1st class`
		public let postageClass: String
		
	}
	
	init(from data: Data) throws {
		let xml = SWXMLHash.parse(data)
		let xmlNames = try xml.byKey("Zones").byKey("name")
		
		var zones = [Zone]()
		for xmlName in xmlNames.all {
			let postageZone = try Zone(id: xmlName.value(ofAttribute: "zoneid"), postageClass: xmlName.value())
			zones.append(postageZone)
		}
		
		self.zones = zones
	}
	
}
