//
//  BigFormInteractor.swift
//  BigForm
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-11 07:55:30 +0000 lobster.kz. All rights reserved.
//

protocol BigFormInteractorInput {
	func submit(_ form: FullForm)
}

// MARK: Implementation

class BigFormInteractor: BigFormInteractorInput {

	weak var output: BigFormInteractorOutput!
	
	func submit(_ form: FullForm) {
		
		let onSuccess = { [weak self] (noContent: Empty) -> Void in
			debugPrint(noContent)
			self?.output.didSucceedSubmitForm()
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailSubmitForm(with: error)
		}
		
		APIAddObject(onSuccess: onSuccess, onFailure: onFailure, fullForm: form).dispatch()
	}

}
		