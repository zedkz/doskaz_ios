//
//  FilterPresenter.swift
//  Filter
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-03 14:19:21 +0000 lobster.kz. All rights reserved.
//
import SharedCodeFramework
		
class FilterPresenter {
	
	weak var view: FilterViewInput!
	var interactor: FilterInteractorInput!
	var router: FilterRouterInput!

	var sharedFilter = Filter.shared
}

// MARK: ViewController output protocol

protocol FilterViewOutput {
	func viewIsReady()
}

extension FilterPresenter: FilterViewOutput {
	func viewIsReady() {
		view.setupInitialState()
		view.onRightButtonTouch = CommandWith<OverallScore> { score in
			self.sharedFilter.acc[score]?.toggle()
			self.view.updateForm(with: self.sharedFilter)
		}
		interactor.loadCategories()
		
	}

}

// MARK: Interactor output protocol

protocol FilterInteractorOutput: class {
	func didLoad(_ categories: [Category])
	func didFailLoadCategories(with error: Error)
}

extension FilterPresenter: FilterInteractorOutput {
	func didLoad(_ categories: [Category]) {
		sharedFilter.cat = categories
		view.makeForm(with: sharedFilter)
	}
	
	func didFailLoadCategories(with error: Error) {
		print("didFailLoacCategories", error)
	}
}
