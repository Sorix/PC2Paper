//
//  LetterAPIAnswer.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Answer for `LetterAPIRequest` have to adopt that protocol, that gives type safety for parsing answers
public protocol LetterAPIAnswer: Decodable {}
