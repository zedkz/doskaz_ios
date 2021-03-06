//
//  FilterBuilder.swift
//  Filter
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-03 14:19:21 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct FilterBuilder {

	func assembleModule() -> FilterViewController {
		let viewController = FilterViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> FilterViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! FilterViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: FilterViewController) {

		let router = FilterRouter()

		let presenter = FilterPresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = FilterInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}
