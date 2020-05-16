//
//  BigFormPresenter.swift
//  BigForm
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-11 07:55:30 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework
		
class BigFormPresenter {
	
	weak var view: BigFormViewInput!
	var interactor: BigFormInteractorInput!
	var router: BigFormRouterInput!
	
	var _atrs: FormAttributes? { didSet { render() } }
	var _cats: [Category]? { didSet { render() } }
	
	func render() {
		if let atrs = _atrs, let cats = _cats {
			view.buildForm(with: atrs, and: cats)
		}
	}

}

// MARK: ViewController output protocol

protocol BigFormViewOutput {
	func viewIsReady()
}

extension BigFormPresenter: BigFormViewOutput {
	func viewIsReady() {
		view.setupInitialState()
		view.onPressReady = CommandWith<FullForm> { fullForm in
			self.submit(fullForm)
		}
		interactor.loadAttributes()
		interactor.loadCategories()
	}
	
	private func submit(_ form: FullForm) {		
		interactor.submit(form)
	}

}

// MARK: Interactor output protocol

protocol BigFormInteractorOutput: class {
	func didSucceedSubmitForm()
	func didFailSubmitForm(with error: Error)
	func didLoad(_ formAttributes: FormAttributes)
	func didFailLoadAttributes(with error: Error)
	func didLoad(_ categories: [Category])
	func didFailLoadCategories(with error: Error)
	
}

extension BigFormPresenter: BigFormInteractorOutput {
	func didLoad(_ categories: [Category]) {
		_cats = categories
	}
	
	func didFailLoadCategories(with error: Error) {
		print("Fail categoruies:", error)
	}
	
	func didLoad(_ formAttributes: FormAttributes) {
		_atrs = formAttributes
	}
	
	func didFailLoadAttributes(with error: Error) {
		print("Fail loading attributes:", error)
	}
	
	func didSucceedSubmitForm() {
		print("didSucceedSubmitForm")
	}
	
	func didFailSubmitForm(with error: Error) {
		print("didFailSubmitForm with error: ",error.localizedDescription)
	}

}
