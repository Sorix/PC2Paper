//
//  PricingAPIRequest.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// All requests to Pricing API have to adopt that protocol
public protocol PricingAPIRequest {
	
	/// Answer for request will be in that type
	associatedtype AnswerModel: PricingAPIAnswer
	
}

internal protocol _PricingAPIRequest {
	var requestString: String { get }
}
