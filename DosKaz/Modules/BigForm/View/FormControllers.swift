//
//  FormControllers.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class FormViewController: TableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableFooterView = UIView()
		tableView.keyboardDismissMode = .onDrag
		tableView.separatorStyle = .none
	}
}

//MARL: - Type that produces form
protocol HasForm {
	var form: FullForm { get }
}


//MARK: - SmallFormViewController

class SmallFormViewController: FormViewController, HasForm {
	
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
		tableView.register(cellClass: TextFormCell.self)
		tableView.register(cellClass: BasicCell.self)
		genInfoSectionSource = FormTableViewDataSource("General Information")
		dataSource = SectionedTableViewDataSource(dataSources: [genInfoSectionSource, genInfoSectionSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	//MARK: - Update methods
	private func update() {
		let exTitle = "Наличие оборудованных парковочных мест (Не менее 1 места на парковке)"
		
		
		let cellProps = TextFormCell.Props(title: exTitle, mode: .full(icon:"clear_search"))
		let cellProps1 = TextFormCell.Props(title: "Наименование", overlay: "available_16", mode: .withoutButton)
		let cellProps2 = TextFormCell.Props(title: "Наименование", mode: .onlyTextField)
		let cellProps3 = TextFormCell.Props(title: "Наименование", overlay: "available_16")


		let configurators: [CellConfiguratorType] = [
			CellConfigurator<TextFormCell>(props: cellProps),
			CellConfigurator<TextFormCell>(props: cellProps1),
			CellConfigurator<TextFormCell>(props: cellProps2),
			CellConfigurator<TextFormCell>(props: cellProps3)
		]
		genInfoSectionSource.configurators = configurators
		tableView.reloadData()
	}
	
	//MARK: - Section Data Sources
	private var dataSource: SectionedTableViewDataSource!
	
	private var genInfoSectionSource: FormTableViewDataSource!
	
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

class MiddleFormViewController: FormViewController {
	
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

class FullFormViewController: FormViewController {
	
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
