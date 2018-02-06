//
//  ZonesLetterCanBeSentFrom.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation
import SWXMLHash

/// This request asks to display postage options are available to the user based on what country they are sending their letter to. Most time that will be your **first request to PricingAPI**.
public struct PostageOptionsRequest: PricingAPIRequest, _PricingAPIRequest {
	
	public typealias AnswerModel = PostageOptionsAnswer
	
	var requestString: String { return "datagetpostage.asp?method=getZonesLetterCanBeSentFrom&str=" + String(countryCode) }
	
	/// The country code we wish to receive available pricing for
	public var countryCode: Int
	
	/// Creates an instance of request
	///
	/// - Parameter countryCode: The country code we wish to receive available pricing for
	public init(countryCode: Int) {
		self.countryCode = countryCode
	}
	
}


/// Answer for `PostageOptionsRequest` request, returning postage options as `Zone`, save `Zone.id` for following requests.
public struct PostageOptionsAnswer: PricingAPIAnswer, _PricingAPIAnswer {
	
	/// Array of zones for that country
	public let zones: [Zone]
	
	// MARK: - Models
	
	/// PC2Paper represents each postage option as a Zone.
	public struct Zone {
		
		/// Zone ID, store it for future API calls
		public let id: Int
		
		/// Example: `UK Signed For 1st class`
		public let postageClass: String
		
		/// Possible human-readable description for the postage class.
		/// - note: That data is not provided by API and it was hard-coded into framework, you can't 100% rely that you always receive expected results from that variable.
		/// You can take actual descriptions from [PC2Paper price calculator](https://www.pc2paper.co.uk/send-letters/postage-prices.aspx)
		public var postageClassDescription: String? { return description(forPostageClass: postageClass) }
		
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

extension PostageOptionsAnswer.Zone {
	
	fileprivate func description(forPostageClass: String) -> String? {
		switch forPostageClass {
		case "UK 1st Class": return "If sent before 3:30pm UK time on a working day your mail will be entered into the postal system. Royal Mail aims to deliver 1st class mail the next day however we have found some mail can take 1 to 3 days. Please note this is not a guaranteed service."
		case "UK 2nd Class": return "If sent before 3:30pm UK time on a working day your mail will be entered into the postal system. Royal Mail aims to deliver 2nd class mail within 2 to 3 days however we have found some mail can take 4 to 5 days. Please note this is not a guaranteed service."
		case "UK Signed For 1st class": return "To use this service you must submit your letter before 1pm UK time on a working day to enter the postal system on the same day.\n\nPlease note that recorded delivery only records delivery of the letter by asking the recipient for a signature. This can be checked online. This is not a guaranteed delivery option and is no faster than sending your letter first class."
		case "UK Special Next Day Delivery": return "To use this service you must submit your letter before 1pm UK time on a working day to enter the postal system on the same day.\n\nSpecial Next Day Delivery is guaranteed by Royal Mail for delivery before 1.00pm the next day. This option can be tracked online and provides electronic proof of delivery."
		case "Airmail from UK": return "Your mail will be sent via Royal Mail Airmail from the UK. Delivery can take (as stated by Royal Mail) 5 - 7 working days however we have found this can sometimes take 10 days in some cases."
		case "1st Class from the USA": return "1st class from the USA. A USA return address must be specified, where a USA address is not used this will default to the address of our US printing partner."
		case "From UK via international tracked and signed for": return "You must submit your mail before 1pm UK time (on a working day) for your mail to be dispatched on the same day.\n\nTracked & Signed is a combination service offering full end-to-end tracking, signature on delivery and an online delivery confirmation."
		case "Airmail From UK to Europe": return "Your mail will be sent via Royal Mail Airmail from the UK. Delivery can take (as stated by Royal Mail) 3 - 5 working days. Please note this is NOT a tracked service."
		default: return nil
		}
	}
	
}
