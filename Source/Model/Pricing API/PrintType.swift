//
//  PrintType.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation
import SWXMLHash

/// This method will request the Print Types available from a selected zone. Print Types are the type of printers the user can have their letter printed on.
public struct PrintTypeRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = PrintTypeAnswer
	
	var requestString: String { return "datagetpostage.asp?method=getPrintType&str=" + String(zoneID) }
	
	/// Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public var zoneID: Int
	
	/// Creates an instance of request
	///
	/// - Parameter zoneID: Zone ID that was saved from `ZonesLetterCanBeSentFromAnswer.Zone.id`
	public init(zoneID: Int) {
		self.zoneID = zoneID
	}
	
}

/// Answer for `PrintTypeRequest` request. This will print types such as `Colour Laser`.
public struct PrintTypeAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Print Types are the type of printers the user can have their letter printed on.
	public let printTypes: [String]
	
	init(from data: Data) throws {
		let xml = SWXMLHash.parse(data)
		self.printTypes = try xml.byKey("PrintType").byKey("name").value()
	}
	
}
