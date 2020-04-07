//
//  LanguageChoiceConfigurator.swift
//  LanguageChoice
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-07 14:08:05 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct LanguageChoiceModuleConfigurator {

	func assembleModule() -> LanguageChoiceViewController {
		let viewController = LanguageChoiceViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> LanguageChoiceViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! LanguageChoiceViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: LanguageChoiceViewController) {

		let router = LanguageChoiceRouter()

		let presenter = LanguageChoicePresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = LanguageChoiceInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}
