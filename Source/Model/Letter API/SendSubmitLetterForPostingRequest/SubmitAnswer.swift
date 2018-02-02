//
//  SendSubmitLetterForPostingAnswer.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

/** Example answer:

```
{
	"d": {
		"__type": "LetterForPostingResult:#PC2Paper.Entity.Public.Letters",
		"CostOfLetter": 0,
		"ErrorMessages": [
		"ER6:There are no addresses in your letter!",
		"ER7:ReceiverCountryCode must be populated with the correct country code please see the documentation.",
		"ER7:You must select a Paper option",
		"ER7:You must select an envelope option"
		],
		"FundsLeftInYourAccount": 0,
		"LetterId": null,
		"Status": "Error"
	}
}
```

**/


import Foundation

/// Result of letter submit request
public struct SubmitLetterForPostingAnswer: LetterAPIAnswer {
	
	let costOfLetter: Double
	let errorMessages: [String]?
	let fundsLeftInYourAccount: Double
	let letterId: String?
	let status: String
	
	// MARK: Decodable
	
	private enum CodingKeys: String, CodingKey {
		case costOfLetter = "CostOfLetter"
		case errorMessages = "ErrorMessages"
		case fundsLeftInYourAccount = "FundsLeftInYourAccount"
		case letterId = "LetterId"
		case status = "Status"
	}
	
	private enum RootCodingKey: String, CodingKey {
		case root = "d"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RootCodingKey.self)
		let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .root)
		
		costOfLetter = try nestedContainer.decode(Double.self, forKey: .costOfLetter)
		errorMessages = try nestedContainer.decodeIfPresent([String].self, forKey: .errorMessages)
		fundsLeftInYourAccount = try nestedContainer.decode(Double.self, forKey: .fundsLeftInYourAccount)
		letterId = try nestedContainer.decodeIfPresent(String.self, forKey: .letterId)
		status = try nestedContainer.decode(String.self, forKey: .status)
	}
	
}
