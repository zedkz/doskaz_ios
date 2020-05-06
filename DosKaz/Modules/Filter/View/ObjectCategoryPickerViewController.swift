//
//  ObjectCategoryPickerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

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
		
	var cellsProps = [BasicCell.Props]()
	
	private var dataSource: TableViewDataSource<BasicCell.Props, BasicCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
		render(cellsProps: cellsProps)
	}
	
	private func render(cellsProps: [BasicCell.Props]) {
		dataSource.cellsProps = cellsProps
		tableView.reloadData()
	}
	
	private func configureTableView() {
		dataSource = TableViewDataSource(tableView) { $1.props = $0}
		tableView.dataSource = dataSource
	}
	
}
