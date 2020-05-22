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
class TableViewDataSource<Props, Cell>: NSObject, UITableViewDataSource, HasTitle where Cell: UITableViewCell {
	
	typealias CellConfigurator = (Props, Cell) -> Void
	
	var cellsProps: [Props]
	var sectionTitle = ""
	private let reuseIdentifier: String
	private let cellConfigurator: CellConfigurator

	init(_ tableView: UITableView,
			 _ sectionTitle: String = "",
			 cellsProps: [Props] = [Props](),
			 reuseIdentifier: String = Cell.reuseIdentifier,
			 cellConfigurator: @escaping CellConfigurator) {
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
		cellConfigurator(cellsProps[indexPath.row], customCell)
		return reusableCell
	}
}

protocol HasTitle {
	var sectionTitle: String { get }
}

typealias TableViewSection = UITableViewDataSource & HasTitle

/// Data source class for all the sections of the
/// table view. It's made my combining TableViewDataSource
class SectionedTableViewDataSource: NSObject {
	private var dataSources: [TableViewSection]
	
	var titles: [String] {
		return dataSources.map{ $0.sectionTitle }
	}
	
	init(dataSources: [TableViewSection]) {
		self.dataSources = dataSources
		for index in 0...20 {
			openBook[index] = true
		}
	}
	
	func replaceDatasources(with dataSources: [TableViewSection]) {
		self.dataSources = dataSources
	}
	
	var openBook = [Int: Bool]()
}

extension SectionedTableViewDataSource: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return dataSources.count
	}
	
	func tableView(_ tableView: UITableView,
								 numberOfRowsInSection section: Int) -> Int {
		let dataSource = dataSources[section]
		return openBook[section]! ? dataSource.tableView(tableView, numberOfRowsInSection: 0) : 0
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

