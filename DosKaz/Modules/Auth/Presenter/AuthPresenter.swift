//
//  AuthPresenter.swift
//  Auth
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-17 07:43:27 +0000 lobster.kz. All rights reserved.
//
import SharedCodeFramework

protocol AuthViewOutput {
	func viewIsReady()
}
		
class AuthPresenter: AuthViewOutput {
	
	weak var view: AuthViewInput!
	var interactor: AuthInteractorInput!
	var router: AuthRouterInput!
	
	var verificationID: String?

	func viewIsReady() {
		view.setupInitialState()
		view.onTouchNext = CommandWith<String> { [weak self] text in
			self?.view.viewPage = .loading
			self?.interactor.verify(phoneNumber: text)
		}
		view.onTouchSend = CommandWith<String> { [weak self] text in
			if let id = self?.verificationID {
				self?.interactor.signIn(with: text, id: id)
			}
		}
	}
	
}


// MARK: Interactor output protocol

protocol AuthInteractorOutput: class {
	func didSucceed(with verificationID: String)
	func didFailVerify(with error: Error)
	func didSucceedSignIn()
	func didFailSignIn(with error: Error)
}

extension AuthPresenter: AuthInteractorOutput {
	func didSucceedSignIn() {
		view.displayAlert(with: "Signed in")
	}
	
	func didFailSignIn(with error: Error) {
		view.displayAlert(with: error.localizedDescription)
	}
	
	func didSucceed(with verificationID: String) {
		print("V code:", verificationID)
		self.verificationID = verificationID
		view.viewPage = .second
	}
	
	func didFailVerify(with error: Error) {
		view.viewPage = .first
		view.displayAlert(with: error.localizedDescription)
	}

}
