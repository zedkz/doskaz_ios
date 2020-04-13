//
//  GreetingConfigurator.swift
//  Greeting
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-12 20:30:47 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct GreetingModuleConfigurator {

	func assembleModule() -> GreetingViewController {
		let viewController = GreetingViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> GreetingViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! GreetingViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: GreetingViewController) {

		let router = GreetingRouter()

		let presenter = GreetingPresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = GreetingInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}