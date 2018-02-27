//
//  PC2Paper.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 31/01/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class LetterAPI {
	
	public static func make<RequestModel: LetterAPIRequest>(request: RequestModel, completion: @escaping (Result<RequestModel.AnswerModel>) -> Void) {
		DispatchQueue.global().async {
			let operation = LetterAPIOperation(request: request)
			operation.fetchCompletionBlock = completion
			operation.start()
		}
	}
	
}
