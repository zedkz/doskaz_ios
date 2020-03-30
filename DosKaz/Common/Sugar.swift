//
//  Sugar.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/29/20.
//  Copyright © 2020 zed. All rights reserved.
//

/// E.g. let result = evaluate(x > 2, ifTrue: 30, ifFalse: 20)
func evaluate<Result>(_ condition: @autoclosure () -> Bool, ifTrue: Result, ifFalse: Result) -> Result {
	return condition() ? ifTrue : ifFalse
}

extension Optional {

	func unwrapped<Result>(with closure: (Wrapped) -> Result,
												 or: Result) -> Result {
		let result = self.map(closure)
		return result ?? or
	}
	
	func unwrapped(with closure: (Wrapped) -> Wrapped = {(result: Wrapped) -> Wrapped in return result },
								 or: Wrapped) -> Wrapped {
		let result =  self.map(closure)
		return result ?? or
	}
	
}
