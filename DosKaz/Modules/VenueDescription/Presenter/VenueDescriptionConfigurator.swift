//
//  VenueDescriptionBuilder.swift
//  VenueDescription
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-27 16:23:49 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct VenueDescriptionBuilder {

	func assembleModule() -> VenueDescriptionViewController {
		let viewController = VenueDescriptionViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> VenueDescriptionViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! VenueDescriptionViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: VenueDescriptionViewController) {

		let router = VenueDescriptionRouter()

		let presenter = VenueDescriptionPresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = VenueDescriptionInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}
