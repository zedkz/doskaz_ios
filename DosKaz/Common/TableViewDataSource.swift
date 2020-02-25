//
//  TableViewDataSource.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/24/20.
//  Copyright © 2020 zed. All rights reserved.
//
import UIKit


/// Data source class for section of the
/// table view. It also registers the cell
/// needed for dequeuing
class TableViewDataSource<Props, Cell>: NSObject, UITableViewDataSource where Cell: UITableViewCell {
	
	typealias CellConfigurator = (Props, Cell) -> Void
	
	var cellsProps: [Props]
	private let reuseIdentifier: String
	private let cellConfigurator: CellConfigurator

	init(_ tableView: UITableView,
			 cellsProps: [Props] = [Props](),
			 reuseIdentifier: String = Cell.reuseIdentifier,
			 cellConfigurator: @escaping CellConfigurator) {
		tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
		self.cellsProps = cellsProps
		self.reuseIdentifier = reuseIdentifier
		self.cellConfigurator = cellConfigurator
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellsProps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let reusableCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		let customCell = reusableCell as! Cell
		cellConfigurator(cellsProps[indexPath.row], customCell)
		return reusableCell
	}
}

/// Data source class for all the sections of the
/// table view. It's made my combining TableViewDataSource
class SectionedTableViewDataSource: NSObject {
	private let dataSources: [UITableViewDataSource]
	
	init(dataSources: [UITableViewDataSource]) {
		self.dataSources = dataSources
	}
}

extension SectionedTableViewDataSource: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return dataSources.count
	}
	
	func tableView(_ tableView: UITableView,
								 numberOfRowsInSection section: Int) -> Int {
		let dataSource = dataSources[section]
		return dataSource.tableView(tableView, numberOfRowsInSection: 0)
	}
	
	func tableView(_ tableView: UITableView,
								 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let dataSource = dataSources[indexPath.section]
		let indexPath = IndexPath(row: indexPath.row, section: 0)
		return dataSource.tableView(tableView, cellForRowAt: indexPath)
	}
}

extension UITableViewCell {
	static var reuseIdentifier: String {
		return String(describing: Self.self)
	}
}

