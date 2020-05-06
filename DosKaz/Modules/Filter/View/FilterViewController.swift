//
//  FilterViewController.swift
//  Filter
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-03 14:19:21 +0000 lobster.kz. All rights reserved.
//

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
		navigationItem.title = l10n(.filter)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(closeFilterForm)
		)
		configureTableView()
	}
		
	func updateForm(with filter: Filter) {
		self.filter = filter
		updateFirstSectionData()
		updateSecondSectionData()
	}
	
	func makeForm(with filter: Filter) {
		self.filter = filter
		updateFirstSectionData()
		updateSecondSectionData()
	}
	
	@objc func closeFilterForm() {
		dismiss(animated: true, completion: nil)
	}

}

class FilterViewController: UIViewController {

	var output: FilterViewOutput!
	let tableView = UITableView(frame: .zero, style: .plain)
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
	
	// MARK: - Private fields
	
	var sectionOneDataSource: TableViewDataSource<BasicCell.Props, BasicCell>!
	var sectionTwoDataSource: TableViewDataSource<BasicCell.Props, BasicCell>!
	var tableViewDataSource: SectionedTableViewDataSource!
	
	private func configureTableView() {
		tableView.tableFooterView = UIView()
		
		/// Data sources
		sectionOneDataSource = TableViewDataSource(tableView) { $1.props = $0 }
		sectionTwoDataSource = TableViewDataSource(tableView) { $1.props = $0 }
		tableViewDataSource = SectionedTableViewDataSource(dataSources: [sectionOneDataSource, sectionTwoDataSource])
		tableView.dataSource = tableViewDataSource
		
		/// Table view layout
		view.addSubview(tableView)
		tableView.addConstraintsProgrammatically
		.pinToSuperSafeArea()
	}

	private func updateFirstSectionData() {
		
		let cellOne = BasicCell.Props(
			text: l10n(.accessibleFull),
			icon: Asset.local("available_32"),
			rightIcon: filter.icon(.fullAccessible),
			onRightButtonTouch: CommandWith {
				self.onRightButtonTouch.perform(with: .fullAccessible)
			}
		)
		let cellTwo = BasicCell.Props(
			text: l10n(.accessiblePartial),
			icon: Asset.local("partially_available_32"),
			rightIcon: filter.icon(.partialAccessible),
			onRightButtonTouch: CommandWith {
				self.onRightButtonTouch.perform(with: .partialAccessible)
			}
		)
		
		let cellThree = BasicCell.Props(
			text: l10n(.accessibleNone),
			icon: Asset.local("not_available_32"),
			rightIcon: filter.icon(.notAccessible),
			onRightButtonTouch: CommandWith {
				self.onRightButtonTouch.perform(with: .notAccessible)
			}
		)
		
		sectionOneDataSource.cellsProps = [cellOne, cellTwo, cellThree]
		tableView.reloadData()
	}
	
	private func updateSecondSectionData() {
		let cells = filter.cat.map { categ in
			return BasicCell.Props(
				text: categ.title,
				icon: Asset.fontAwesome(categ.icon),
				rightIcon: "chevron_right_passive",
				onRightButtonTouch: CommandWith {
					print("Cate is chosen")
				}
			)
		}
		
		sectionTwoDataSource.cellsProps = cells
		tableView.reloadData()
	}
	
}
