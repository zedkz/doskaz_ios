//
//  UTableViewDataSource.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

/// Data source class for section of the
/// table view. It also registers the cell
/// needed for dequeuing
/// ex: let dataSource = TableViewDataSource<CustomCell>(tableViewInstance)
class UTableViewDataSource<Cell>: NSObject, UITableViewDataSource, HasTitle
where Cell: UITableViewCell, Cell: Updatable {
	
	typealias CellConfigurator = (Cell) -> Void
	
	var cellsProps: [Cell.CellProps]
	var sectionTitle = ""
	private let reuseIdentifier: String
	private let cellConfigurator: CellConfigurator
	
	
	init(_ tableView: UITableView,
			 _ sectionTitle: String = "",
			 cellsProps: [Cell.CellProps] = [],
			 reuseIdentifier: String = Cell.reuseIdentifier,
			 cellConfigurator: @escaping CellConfigurator
	) {
		tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
		self.sectionTitle = sectionTitle
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
		customCell.props = cellsProps[indexPath.row]
		cellConfigurator(customCell)
		return reusableCell
	}
}
