//
//  AsynchronousOperation.swift
//  PC2Paper
//
//  Created by Vasily Ulianov on 09/02/2018.
//  Copyright © 2018 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Subclass of `Operation` that adds support of asynchronous operations.
/// ## How to use:
/// 1. Call `super.main()` when override `main` method, call `super.start()` when override `start` method.
/// 2. When operation is finished or cancelled set `self.state = .finished`
public class AsynchronousOperation: Operation {
	override public var isAsynchronous: Bool { return true }
	override public var isExecuting: Bool { return state == .executing }
	override public var isFinished: Bool { return state == .finished }
	
	var state = State.ready {
		willSet {
			willChangeValue(forKey: state.keyPath)
			willChangeValue(forKey: newValue.keyPath)
		}
		didSet {
			didChangeValue(forKey: state.keyPath)
			didChangeValue(forKey: oldValue.keyPath)
		}
	}
	
	enum State: String {
		case ready = "Ready"
		case executing = "Executing"
		case finished = "Finished"
		fileprivate var keyPath: String { return "is" + self.rawValue }
	}
	
	override public func start() {
		if self.isCancelled {
			state = .finished
		} else {
			state = .ready
			main()
		}
	}
	
	override public func main() {
		if self.isCancelled {
			state = .finished
		} else {
			state = .executing
		}
	}
}
