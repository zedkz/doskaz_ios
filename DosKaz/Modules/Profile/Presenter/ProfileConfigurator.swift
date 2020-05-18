//
//  ProfileBuilder.swift
//  Profile
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-18 08:16:13 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct ProfileBuilder {
	
	func assembleTab() -> UIViewController {
		return assembleModule().tab(with: "user", title: l10n(.profile))
	}

	func assembleModule() -> ProfileViewController {
		let viewController = ProfileViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> ProfileViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! ProfileViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: ProfileViewController) {

		let router = ProfileRouter()

		let presenter = ProfilePresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = ProfileInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}
