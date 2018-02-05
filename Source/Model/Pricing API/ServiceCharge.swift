//
//  ServiceCharge.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 06/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// This request with given a zoneid returns the service charge that will be applied to the letter. *This method is only supplied for informative purposes.*
public struct ServiceChargeRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = TotalLetterCostAnswer
	
	var requestString: String { return "datagetpostage.asp?method=getServiceChargeBasedOnZone&str=" + String(zoneID) }
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Creates an instance of request
	///
	/// - Parameter zoneID: Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public init(zoneID: Int) {
		self.zoneID = zoneID
	}
	
}

/// Answer for `ServiceChargeRequest` request, returning the service charge that will be applied to the letter.
public struct ServiceChargeAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Total cost of the letter
	public let cost: Double
	
	init(from data: Data) throws {
		guard let text = String(data: data, encoding: .utf8),
			let cost = Double(text) else {
				throw ApiError.parseFailed(error: nil)
		}
		
		self.cost = cost
	}
	
}
