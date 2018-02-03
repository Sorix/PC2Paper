//
//  PaperType.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation
import SWXMLHash

/// This structure creates a request for a list of "Paper Types" available for the selected Print Type and Zone ID.
public struct PaperTypeRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = PaperTypeAnswer
	
	var requestString: String {
		var base = "datagetpostage.asp?method=getPaperBasedOnZoneAndPrintType&str="
		base += String(zoneID) + ","
		base += printType.escaped()
		return base
	}
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Print type that was received from `PrintTypeAnswer.printTypes`
	public var printType: String
	
	/// Creates an instance of request
	///
	/// - Parameter zoneID: Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	/// - Parameter printType: print type that was received from `PrintTypeAnswer.printTypes`
	public init(zoneID: Int, printType: String) {
		self.zoneID = zoneID
		self.printType = printType
	}
	
}

/// Answer for `PaperTypeRequest` request with papers types.
public struct PaperTypeAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	public struct Paper {
		public let id: Int
		public let cost: Double
		public let name: String
	}

	/// Array of paper types, such as `White gloss photo paper 170 gsm`
	public let paperTypes: [Paper]
	
	init(from data: Data) throws {
		let xml = SWXMLHash.parse(data)
		let xmlNames = try xml.byKey("PrintType").byKey("name")
		
		var papers = [Paper]()
		for xmlName in xmlNames.all {
			let newPaper = try Paper(id: xmlName.value(ofAttribute: "itemID"),
									 cost: xmlName.value(ofAttribute: "cost"),
									 name: xmlName.value())
			papers.append(newPaper)
		}
		
		self.paperTypes = papers
	}
}

