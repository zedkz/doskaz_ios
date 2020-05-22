//
//  ProfileInteractor.swift
//  Profile
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-18 08:16:13 +0000 lobster.kz. All rights reserved.
//

protocol ProfileInteractorInput {
	func loadProfile() -> Void
}

// MARK: Implementation

class ProfileInteractor: ProfileInteractorInput {

	weak var output: ProfileInteractorOutput!
	
	func loadProfile() -> Void {
		let onSuccess = { [weak self] (profile: Profile) -> Void in
			self?.output.didLoad(profile)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoad(error)
		}
		
		APIProfile(onSuccess: onSuccess, onFailure: onFailure).dispatch()
		
	}

}
		