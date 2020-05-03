//
//  FilterPresenter.swift
//  Filter
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-03 14:19:21 +0000 lobster.kz. All rights reserved.
//
		
class FilterPresenter {
	
	weak var view: FilterViewInput!
	var interactor: FilterInteractorInput!
	var router: FilterRouterInput!

}

// MARK: ViewController output protocol

protocol FilterViewOutput {
	func viewIsReady()
}

extension FilterPresenter: FilterViewOutput {
	func viewIsReady() {
		view.setupInitialState()
	}

}

// MARK: Interactor output protocol

protocol FilterInteractorOutput: class {

}

extension FilterPresenter: FilterInteractorOutput {

}
