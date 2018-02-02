//
//  PricingAPIAnswer.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public protocol PricingAPIAnswer {}

internal protocol _PricingAPIAnswer: PricingAPIAnswer {
	
	init(from xml: Data) throws
	
}
