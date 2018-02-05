//
//  TotalLetterCost.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 03/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// This request asks to calculate the total cost of the letter given the results of the previous API methods.
public struct TotalLetterCostRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = TotalLetterCostAnswer
	
	var requestString: String {
		let params = [String(zoneID), String(paperTypeID), String(numberOfPages), String(zoneOfferID), String(envelopeTypeID)]
		return "datagetpostage.asp?method=getTotalForLetterByPages&str=" + params.joined(separator: ",")
	}
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Paper type ID received from `PaperTypeAnswer.Paper.id` answer
	public var paperTypeID: Int
	
	/// Number of pages in your letter
	public var numberOfPages: Int
	
	/// Zone offer ID received from `ZoneOffersAnswer.Offer.id`
	public var zoneOfferID: Int
	
	/// Envelope type ID received from `EnvelopesAvailableAnswer.EnvelopeType.id`
	public var envelopeTypeID: Int
	
	/// Creates an instance of request
	public init(zoneID: Int, paperTypeID: Int, numberOfPages: Int, zoneOfferID: Int, envelopeTypeID: Int) {
		self.zoneID = zoneID
		self.paperTypeID = paperTypeID
		self.numberOfPages = numberOfPages
		self.zoneOfferID = zoneOfferID
		self.envelopeTypeID = envelopeTypeID
	}
	
}

/// Answer for `TotalLetterCostRequest` request, returning total cost of the letter given the results of the previous API methods.
public struct TotalLetterCostAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Total cost of the letter
	public let cost: Double
	
	init(from data: Data) throws {
		guard let text = String(data: data, encoding: .utf8),
			let cost = Double(text) else {
				let error = TextError("Failed to convert data to text and to Int")
				throw ApiError.parseFailed(error: error)
		}
		
		self.cost = cost
	}
	
}
