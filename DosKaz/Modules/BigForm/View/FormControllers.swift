//
//  FormControllers.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

//MARL: - Type that produces form
protocol HasForm {
	var form: FullForm { get }
}


//MARK: - SmallFormViewController

class SmallFormViewController: TableViewController, HasForm {
	
	var form: FullForm {
		let first = First(
			name: "name",
			description: "desc",
			otherNames: "other",
			address: "adr",
			categoryId: 13,
			point: [3423,32423],
			videos: [FullFormPhoto(data: "dsf")],
			photos: [FullFormPhoto(data: "34")]
		)
		
		let parkingSection = FormSection(
			attributes: FormAttributeGenerator.generate(),
			comment: "dsf"
		)
		let entranceSection = FormSection(
			attributes: FormAttributeGenerator.generate(),
			comment: "dsf"
		)
		
		let form = FullForm(
			form: "small",
			first: first,
			parking: parkingSection,
			entrance1: entranceSection,
			movement: parkingSection,
			service: parkingSection,
			toilet: parkingSection,
			navigation: parkingSection,
			serviceAccessibility: parkingSection
		)
		
		return form
	}	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		update()
	}
	
	private func setup() {
		genInfoSectionSource = TableViewDataSource(tableView, "General Information") { $1.props = $0}
		dataSource = SectionedTableViewDataSource(dataSources: [genInfoSectionSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
		tableView.tableFooterView = UIView()
	}
	
	//MARK: - Update methods
	private func update() {
		let cellsProps = [
			TextFormCell.Props(title: "Наименование")
		]
		
		genInfoSectionSource.cellsProps = cellsProps
		tableView.reloadData()
	}
	
	//MARK: - Section Data Sources
	private var dataSource: SectionedTableViewDataSource!
	
	private var genInfoSectionSource: TableViewDataSource<TextFormCell.Props, TextFormCell>!
	
}

extension SmallFormViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let cell = UITableViewCell()
		cell.backgroundColor = UIColor(named:"FilterHeaderColor")
		cell.textLabel?.textColor = UIColor(named: "FilterHeaderTextColor")
		cell.textLabel?.font = .systemFont(ofSize: 13)
		cell.textLabel?.text = dataSource.titles[section].uppercased()
		return cell
	}
}


//MARK: - MiddleFormViewController

class MiddleFormViewController: TableViewController {
	
	private var dataSource: TableViewDataSource<BasicCell.Props, BasicCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		dataSource = TableViewDataSource(tableView) { $1.props = $0}
		tableView.dataSource = dataSource
		
		let cellsProps = [
			BasicCell.Props(
				text: "Dravel",
				icon: Asset.fontAwesome("fa-plus"),
				rightIcon: "chevron_right_active"
			)
		]
		
		dataSource.cellsProps = cellsProps
		
		tableView.reloadData()
	}
	
}


//MARK: - FullFormViewController

class FullFormViewController: TableViewController {
	
	private var dataSource: TableViewDataSource<BasicCell.Props, BasicCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		dataSource = TableViewDataSource(tableView) { $1.props = $0}
		tableView.dataSource = dataSource
		
		let cellsProps = [
			BasicCell.Props(
				text: "Full",
				icon: Asset.fontAwesome("fa-minus"),
				rightIcon: "chevron_left_active"
			)
		]
		
		dataSource.cellsProps = cellsProps
		
		tableView.reloadData()
	}
	
}
