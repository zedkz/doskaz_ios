//
//  FilterViewController.swift
//  Filter
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-03 14:19:21 +0000 lobster.kz. All rights reserved.
//

import Eureka
import SharedCodeFramework

// MARK: View input protocol

protocol FilterViewInput where Self: UIViewController {
	func setupInitialState()
	func makeForm(with filter: Filter)
	func updateForm(with filter: Filter)
	
	var onRightButtonTouch: CommandWith<OverallScore> { get set }
}

extension FilterViewController: FilterViewInput {

	func setupInitialState() {
		view.backgroundColor = .white
		tableView.tableFooterView = UIView()
		navigationItem.title = l10n(.filter)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(closeFilterForm)
		)
	}
		
	func updateForm(with filter: Filter) {
		self.filter = filter
		form.rowBy(tag: Tag.accessibleFull.raw)?.reload()
		form.rowBy(tag: Tag.accessiblePartial.raw)?.reload()
		form.rowBy(tag: Tag.accessibleNone.raw)?.reload()
	}
	
	func makeForm(with filter: Filter) {
		self.filter = filter
		createForm()
	}
	
	@objc func closeFilterForm() {
		
	}

}

class FilterViewController: FormViewController {

	var output: FilterViewOutput!
	
	var onRightButtonTouch: CommandWith<OverallScore> = .nop
	
	var filter = Filter() {
		didSet {
			print("Filter has been set")
		}
	}

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}
	
	private func createForm() { form
		+++ FF.section(with: l10n(.objectAccessibility), tag: Tag.firstSection.raw)

		<<< FormTextRow(Tag.accessibleFull.raw, {
			$0.value = BasicCell.Props(
				text: l10n(.accessibleFull),
				icon: Asset.local("available_32"),
				rightIcon: filter.icon(.fullAccessible),
				onRightButtonTouch: CommandWith {
					self.onRightButtonTouch.perform(with: .fullAccessible)
				}
			)
		}).cellUpdate{ (cell, row) in
			cell.update(\.rightIcon, with: self.filter.icon(.fullAccessible))
		}
		
		<<< FormTextRow(Tag.accessiblePartial.raw, {
			$0.value = BasicCell.Props(
				text: l10n(.accessiblePartial),
				icon: Asset.local("partially_available_32"),
				rightIcon: filter.icon(.partialAccessible),
				onRightButtonTouch: CommandWith {
					self.onRightButtonTouch.perform(with: .partialAccessible)
				}
			)
		}).cellUpdate{ (cell, row) in
			cell.update(\.rightIcon, with: self.filter.icon(.partialAccessible))
		}
		
		<<< FormTextRow(Tag.accessibleNone.raw, {
			$0.value = BasicCell.Props(
				text: l10n(.accessibleNone),
				icon: Asset.local("not_available_32"),
				rightIcon: filter.icon(.notAccessible),
				onRightButtonTouch: CommandWith {
					self.onRightButtonTouch.perform(with: .notAccessible)
				}
			)
		}).cellUpdate{ (cell, row) in
			cell.update(\.rightIcon, with: self.filter.icon(.notAccessible))
		}
		
	}
	
	// MARK: -Subtypes
	
	enum Tag: String {
		case accessibleFull
		case accessiblePartial
		case accessibleNone
		
		case firstSection
		
		var raw: String {
			return rawValue
		}
	}

}
