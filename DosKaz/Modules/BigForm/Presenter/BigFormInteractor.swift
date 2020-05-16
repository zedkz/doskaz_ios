//
//  BigFormInteractor.swift
//  BigForm
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-11 07:55:30 +0000 lobster.kz. All rights reserved.
//

protocol BigFormInteractorInput {
	func submit(_ form: FullForm)
	func loadAttributes()
	func loadCategories()
}

// MARK: Implementation

class BigFormInteractor: BigFormInteractorInput {

	weak var output: BigFormInteractorOutput!
	
	func loadCategories() {
		if let storedCats = CategoriesStorage.shared.retrieveData() {
			output.didLoad(storedCats)
		}
		
		let onSuccess = { [weak self] (categories: [Category]) -> Void in
			self?.output.didLoad(categories)
			CategoriesStorage.shared.store(categories)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadCategories(with: error)
		}
		
		APICategories(onSuccess: onSuccess, onFailure: onFailure).dispatch()
	}
	
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
	
	
	func loadAttributes() {
		if let attrs = FormAttributesStorage.shared.retrieveData() {
			output.didLoad(attrs)
		}
		let onSuccess = { [weak self] (formAttributes: FormAttributes) -> Void in
			self?.output.didLoad(formAttributes)
			FormAttributesStorage.shared.store(formAttributes)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadAttributes(with: error)
		}
		
		APIFormAttributes(onSuccess: onSuccess, onFailure: onFailure).dispatch()
		
	}

}
		
