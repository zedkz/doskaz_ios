//
//  GreetingRouter.swift
//  Greeting
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-12 20:30:47 +0000 lobster.kz. All rights reserved.
//

import UIKit

protocol GreetingRouterInput {
	func presentCategories(with viewController: UIViewController)
}

// MARK: Implementation

class GreetingRouter: GreetingRouterInput {
	func presentCategories(with viewController: UIViewController) {
		viewController.navigationController?.pushViewController(
			CategoryPickerModuleConfigurator().assembleModule(), animated: true
		)
	}
}
