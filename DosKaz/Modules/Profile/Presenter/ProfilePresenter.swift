//
//  ProfilePresenter.swift
//  Profile
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-18 08:16:13 +0000 lobster.kz. All rights reserved.
//
		
class ProfilePresenter {
	
	weak var view: ProfileViewInput!
	var interactor: ProfileInteractorInput!
	var router: ProfileRouterInput!

}

// MARK: ViewController output protocol

protocol ProfileViewOutput {
	func viewIsReady()
}

extension ProfilePresenter: ProfileViewOutput {
	func viewIsReady() {
		view.setupInitialState()
		interactor.loadProfile()
	}

}

// MARK: Interactor output protocol

protocol ProfileInteractorOutput: class {
	func didLoad(_ profile: Profile)
	func didFailLoad(_ error: Error)
}

extension ProfilePresenter: ProfileInteractorOutput {
	func didFailLoad(_ error: Error) {
		print("didFailLoad: ", error)
	}
	
	func didLoad(_ profile: Profile) {
		print("Profile: ",profile)
		view.profileView.props = ProfileView.Props(profile: profile)
	}

}
