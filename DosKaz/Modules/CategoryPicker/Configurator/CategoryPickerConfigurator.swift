//
//  CategoryPickerConfigurator.swift
//  CategoryPicker
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-24 12:15:36 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct CategoryPickerModuleConfigurator {

	func assembleModule() -> CategoryPickerViewController {
		let viewController = CategoryPickerViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> CategoryPickerViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! CategoryPickerViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: CategoryPickerViewController) {

		let router = CategoryPickerRouter()

		let presenter = CategoryPickerPresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = CategoryPickerInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}
