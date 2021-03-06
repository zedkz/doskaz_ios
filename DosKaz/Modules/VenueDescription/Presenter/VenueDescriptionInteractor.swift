//
//  VenueDescriptionInteractor.swift
//  VenueDescription
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-27 16:23:49 +0000 lobster.kz. All rights reserved.
//

protocol VenueDescriptionInteractorInput {
	func verifyVenue(with id: Int, status: Status)
}

// MARK: Implementation

class VenueDescriptionInteractor: VenueDescriptionInteractorInput {

	weak var output: VenueDescriptionInteractorOutput!
	
	func verifyVenue(with id: Int, status: Status) {
		APIVerifyObject(onSuccess: { [weak self] _ in
			self?.output?.didSucceedVerify()
		}, onFailure: { [weak self] error in
			self?.output?.didFailVerify(with: error)
		}, id: id,
			 status: status
		)
		.dispatch()
	}

}
		
