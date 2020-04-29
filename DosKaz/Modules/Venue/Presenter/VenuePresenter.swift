//
//  VenuePresenter.swift
//  Venue
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-26 12:44:17 +0000 lobster.kz. All rights reserved.
//
		
class VenuePresenter {
	
	weak var view: VenueViewInput!
	var interactor: VenueInteractorInput!
	var router: VenueRouterInput!

}

// MARK: ViewController output protocol

protocol VenueModuleInput {
	func show(_ venue: DoskazVenue)
}

protocol VenueViewOutput: VenueModuleInput {
	func viewIsReady()
}

extension VenuePresenter: VenueViewOutput {
	func viewIsReady() {
		view.setupInitialState()
	}
	
	func show(_ venue: DoskazVenue) {
		print("VenuePresenter:",venue.title)
		guard let view = view else { return }
		view.setup(venueProps: UIVenueView.VenueProps(doskazVenue: venue))
	}

}

// MARK: Interactor output protocol

protocol VenueInteractorOutput: class {

}

extension VenuePresenter: VenueInteractorOutput {

}
