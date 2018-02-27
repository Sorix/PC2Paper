//
//  PricingAPI.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 02/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

public class PricingAPI {
	
	public static func make<RequestModel: PricingAPIRequest>(request: RequestModel, completion: @escaping (Result<RequestModel.AnswerModel>) -> Void) {
		DispatchQueue.global().async {
			let operation = PricingAPIOperation(request: request)
			operation.fetchCompletionBlock = completion
			operation.start()
		}
	}
	
}
