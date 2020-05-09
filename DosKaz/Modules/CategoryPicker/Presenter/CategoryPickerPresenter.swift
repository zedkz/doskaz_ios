//
//  CategoryPickerPresenter.swift
//  CategoryPicker
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-24 12:15:36 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework
		
class CategoryPickerPresenter: CategoryPickerModuleInput {
	
	weak var view: CategoryPickerViewInput!
	var interactor: CategoryPickerInteractorInput!
	var router: CategoryPickerRouterInput!

}


// MARK: ViewController output protocol

protocol CategoryPickerViewOutput {
	func viewIsReady()
}

extension CategoryPickerPresenter: CategoryPickerViewOutput {
	func viewIsReady() {
		view.setupInitialState()
		let handicaps = DisabilityCategories().load()
		
		let categories = handicaps.map { handicap in
			return CategoryPickerViewController.Category(
				name: handicap.title,
				imageName: handicap.icon,
				onPickCategory: CommandWith<CategoryPickerViewController.Category> { category in
					print(category)
					self.router.presentMainTabbar()
			})
		}
		
		view.update(with: categories)
	}

}


// MARK: Interactor output protocol

protocol CategoryPickerInteractorOutput: class {

}

extension CategoryPickerPresenter: CategoryPickerInteractorOutput {

}

