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
	
	var requestString: String {
		return "datagetpostage.asp?method=getZonesLetterCanBeSentFrom&str=" + String(countryCode) }
	
	public var countryCode: Int
	
	public init(countryCode: Int) {
		self.countryCode = countryCode
	}
	
}

public struct ZonesLetterCanBeSentFromAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	struct Zone {
		let id: Int
		let postageClass: String
	}
	
	let zones: [Zone]
	
	init(from data: Data) throws {
		let xml = SWXMLHash.parse(data)
		
		let xmlZones = try xml.byKey("Zones")
		let xmlNames = try xmlZones.byKey("name")
		
		var zones = [Zone]()
		for xmlName in xmlNames.all {
			guard let zoneIdText = xmlName.element?.attribute(by: "zoneid")?.text,
				let zoneId = Int(zoneIdText),
				let postageClass = xmlName.element?.text else {
					let textError = ApiError.error(descriptions: ["Zoneid element is incorrect"])
					throw ApiError.parseFailed(error: textError)
			}
			
			let postageZone = Zone(id: zoneId, postageClass: postageClass)
			zones.append(postageZone)
		}
		
		self.zones = zones
	}
	
}
