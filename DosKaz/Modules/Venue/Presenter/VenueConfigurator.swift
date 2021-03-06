//
//  VenueBuilder.swift
//  Venue
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-26 12:44:17 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct VenueBuilder {

	func assembleModule() -> VenueViewController {
		let viewController = VenueViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> VenueViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! VenueViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: VenueViewController) {

		let router = VenueRouter()

		let presenter = VenuePresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = VenueInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}
