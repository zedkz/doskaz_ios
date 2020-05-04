//
//  FilterViewController.swift
//  Filter
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-03 14:19:21 +0000 lobster.kz. All rights reserved.
//

import Eureka

// MARK: View input protocol

protocol FilterViewInput where Self: UIViewController {
	func setupInitialState()
}

extension FilterViewController: FilterViewInput {

	func setupInitialState() {
		view.backgroundColor = .white
		tableView.tableFooterView = UIView()
		navigationItem.title = l10n(.filter)
		createForm()
	}

}

class FilterViewController: FormViewController {

	var output: FilterViewOutput!

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}
	
	private func createForm() { form
		+++ FF.section(with: l10n(.objectAccessibility))
		<<< TextRow("1", {
			$0.title = "Text row"
			$0.value = "Value of a text row"
		})
		
		<<< FormTextRow(Tag.accessibleFull.raw, {
			$0.value = BasicCell.Props(
				text: l10n(.accessibleFull),
				icon: Asset.local("available_32"),
				rightIcon: "not_available_32"
			)
		})
		
		<<< FormTextRow(Tag.accessiblePartial.raw, {
			$0.value = BasicCell.Props(
				text: l10n(.accessiblePartial),
				icon: Asset.local("partially_available_32"),
				rightIcon: "not_available_32"
			)
		})
		
		<<< FormTextRow(Tag.accessibleNone.raw, {
			$0.value = BasicCell.Props(
				text: l10n(.accessibleNone),
				icon: Asset.local("not_available_32"),
				rightIcon: "not_available_32"
			)
		})
		
	}
	
	// MARK: -Subtypes
	
	enum Tag: String {
		case accessibleFull
		case accessiblePartial
		case accessibleNone
		
		var raw: String {
			return rawValue
		}
	}

}
