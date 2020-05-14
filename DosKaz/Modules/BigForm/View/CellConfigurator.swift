//
//  CellConfigurator.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

// TODO: Add to Shared
protocol Updatable: class {
	associatedtype CellProps
	var props: CellProps! { get set }
}

protocol CellConfiguratorType: HasValidatable{
	var reuseIdentifier: String { get }
	var onSelect: Command { get }
	func update(cell: UITableViewCell)
}

protocol HasValidatable {
	var validatable: Validatable? { get }
}

extension HasValidatable {
	var validatable: Validatable? { nil }
}

struct CellConfigurator<Cell>: CellConfiguratorType where Cell: Updatable, Cell: UITableViewCell {
		
	let props: Cell.CellProps
	var onSelect: Command = .nop
	var reuseIdentifier: String { Cell.reuseIdentifier }
	
	func update(cell: UITableViewCell) {
		if let cell = cell as? Cell {
			cell.props = props
		}
	}
	
	var validatable: Validatable? {
		return props as? Validatable
	}
}

class FormTableViewDataSource: NSObject, UITableViewDataSource, HasTitle {

	var sectionTitle = ""
	var configurators: [CellConfiguratorType]
	
	init(_ sectionTitle: String = "", _ configurators: [CellConfiguratorType] = []) {
		self.sectionTitle = sectionTitle
		self.configurators = configurators
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return configurators.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cf = configurators[indexPath.row]
		let reusableCell = tableView.dequeueReusableCell(withIdentifier: cf.reuseIdentifier, for: indexPath)
		cf.update(cell: reusableCell)
		return reusableCell
	}
	
}

extension UITableView {
	func register<T: UITableViewCell>(cellClass: T.Type) {
		register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
	}
}
