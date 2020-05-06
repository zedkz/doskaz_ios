//
//  ObjectCategoryPickerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class TableViewController: UIViewController {
	let tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.addSubview(tableView)
		tableView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
	}
	
}

class ObjectCategoryPickerViewController: TableViewController {
		
	var category: Category! {
		didSet {
			navigationItem.title = category.title
			updateCellsProps()
		}
	}

	func updateCellsProps() {
		cellsProps = category.subCategories.map { subCategory in
			return BasicCell.Props(
				text: subCategory.title,
				icon: Asset.fontAwesome(subCategory.icon),
				rightIcon: Filter.shared.icon(category, sub: subCategory),
				onRightButtonTouch: Command {
					Filter.shared.toggle(self.category, subCategory)
					self.updateCellsProps()
					self.render(cellsProps: self.cellsProps)
				}
			)
		}
	}
	var cellsProps = [BasicCell.Props]()
	
	private var dataSource: TableViewDataSource<BasicCell.Props, BasicCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
		render(cellsProps: cellsProps)
	}
	
	private func render(cellsProps: [BasicCell.Props]) {
		let pickAll = BasicCell.Props(
			text: l10n(.pickAll),
			icon: Asset.local("confirm_button"),
			rightIcon: Filter.shared.iconPickAll(for: category),
			onRightButtonTouch: Command {
				Filter.shared.toggleAll(for: self.category)
				self.updateCellsProps()
				self.render(cellsProps: self.cellsProps)
			}
		)
		
		dataSource.cellsProps = cellsProps
		dataSource.cellsProps.insert(pickAll, at: 0)
		tableView.reloadData()
	}
	
	private func configureTableView() {
		dataSource = TableViewDataSource(tableView) { $1.props = $0}
		tableView.dataSource = dataSource
	}
	
}
