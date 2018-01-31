//
//  ErrorAnswer.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

struct ErrorAnswer: Answer {
	
	let errorMessages: [String]
	
	private enum CodingKeys: String, CodingKey {
		case errorMessages = "ErrorMessages"
	}
	
	private enum RootCodingKey: String, CodingKey {
		case root = "d"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RootCodingKey.self)
		let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .root)
		
		errorMessages = try nestedContainer.decode([String].self, forKey: .errorMessages)
	}
	
}
