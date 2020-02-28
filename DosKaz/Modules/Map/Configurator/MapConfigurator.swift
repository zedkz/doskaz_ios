//
//  MapConfigurator.swift
//  Map
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-23 16:55:07 +0000 lobster.kz. All rights reserved.
//

import UIKit

struct MapModuleConfigurator {
	
	func assembleTab() -> UIViewController {
		return assembleModule().tab(with: "tab_icon_map", title: l10n(.map))
	}

	func assembleModule() -> MapViewController {
		let viewController = MapViewController()
		configure(viewController: viewController)
		return viewController
	}

	func assembleModule(with storyBoardName: String) -> MapViewController {
		let storyboard = UIStoryboard(name: storyBoardName, bundle: .main)
		let viewController = storyboard.instantiateInitialViewController() as! MapViewController
		configure(viewController: viewController)
		return viewController
	}

	private func configure(viewController: MapViewController) {

		let router = MapRouter()

		let presenter = MapPresenter()
		presenter.view = viewController
		presenter.router = router

		let interactor = MapInteractor()
		interactor.output = presenter

		presenter.interactor = interactor
		viewController.output = presenter
	}

}
