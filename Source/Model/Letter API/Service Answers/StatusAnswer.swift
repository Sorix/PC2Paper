//
//  StatusAnswer.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 01/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

struct StatusAnswer: LetterAPIAnswer {
	
	let status: String
	
	private enum CodingKeys: String, CodingKey {
		case status = "Status"
	}
	
	private enum RootCodingKey: String, CodingKey {
		case root = "d"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RootCodingKey.self)
		let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .root)
		
		status = try nestedContainer.decode(String.self, forKey: .status)
	}
	
	
}
