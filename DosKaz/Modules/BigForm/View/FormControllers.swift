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
		tableView.keyboardDismissMode = .interactive
		tableView.separatorStyle = .none
	}
}

//MARL: - Type that produces form
protocol HasForm {
	var form: FullForm { get }
}


//MARK: - SmallFormViewController

class SmallFormViewController: FormViewController, HasForm {
	
	var first: First = {
		var first = First(
			name: "",
			description: "",
			otherNames: "",
			address: "",
			categoryId: 0,
			point: [],
			videos: [],
			photos: [])
//		let second = First(
//			name: "name",
//			description: "desc",
//			otherNames: "other",
//			address: "adr",
//			categoryId: 13,
//			point: [3423,32423],
//			videos: [FullFormPhoto(data: "dsf")],
//			photos: [FullFormPhoto(data: "34")]
//		)
		return first
	}()
	
	var form: FullForm {

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
		genInfoSectionSource = FormTableViewDataSource(l10n(.genInfo))
		dataSource = SectionedTableViewDataSource(dataSources: [genInfoSectionSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	//MARK: - Update methods
	private func update() {
		
		let objectName = TextFormCell.Props(
			text: first.name,
			title: l10n(.objName),
			mode: .full(icon: "help_in_form"),
			onEditText: Text { self.first.name = $0 }
		)
		
		let address = TextFormCell.Props(
			text: first.address,
			title: l10n(.objAddress),
			mode: .full(icon: "help_in_form"),
			onEditText: Text { self.first.address = $0 }
		)
		
		let points = first.point.reduce("") { (partial, point) -> String in
			return partial + String(point)
		}
		
		let objOnmap = TextFormCell.Props(
			text: points,
			title: l10n(.objOnMap),
			overlay: "map_1",
			mode: .withoutButton,
			onEditText: Text { _ in self.first.point = [12,43] }
		)
		
		let category = TextFormCell.Props(
			text: "",
			title: l10n(.objCategory),
			overlay: "chevron_down",
			mode: .full(icon: "help_in_form"),
			onEditText: Text { print($0) }
		)
		
		let subCategory = TextFormCell.Props(
			text: "",
			title: l10n(.objSubCategory),
			overlay: "chevron_down",
			mode: .full(icon: "help_in_form"),
			onEditText: Text { print($0) }
		)
		
		let videoLink = TextFormCell.Props(
			text: "",
			title: l10n(.videoLink),
			mode: .full(icon: "x_in_form"),
			onEditText: Text { print($0) }
		)

		let configurators: [CellConfiguratorType] = [
			CellConfigurator<TextFormCell>(props: objectName),
			CellConfigurator<TextFormCell>(props: address),
			CellConfigurator<TextFormCell>(props: objOnmap),
			CellConfigurator<TextFormCell>(props: category),
			CellConfigurator<TextFormCell>(props: subCategory),
			CellConfigurator<TextFormCell>(props: videoLink)
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
