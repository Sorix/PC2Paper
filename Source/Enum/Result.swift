//
//  Result.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public enum Result<T> {
	case succeed(T)
	case failed(Error)
}
