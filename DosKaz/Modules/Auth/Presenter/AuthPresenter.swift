//
//  AuthPresenter.swift
//  Auth
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-17 07:43:27 +0000 lobster.kz. All rights reserved.
//


protocol AuthViewOutput {
	func viewIsReady()
}
		
class AuthPresenter: AuthViewOutput {
	
	weak var view: AuthViewInput!
	var interactor: AuthInteractorInput!
	var router: AuthRouterInput!

	func viewIsReady() {
		view.setupInitialState()
	}
	
}


// MARK: Interactor output protocol

protocol AuthInteractorOutput: class {

}

extension AuthPresenter: AuthInteractorOutput {

}
