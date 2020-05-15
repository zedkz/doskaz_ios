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
	
	func buildForm(with formAttrs: FormAttributes) {
		print("Super's implementation of build form")
	}
}

//MARL: - Type that produces form
protocol HasForm {
	var form: FullForm? { get }
}


//MARK: - SmallFormViewController

class SmallFormViewController: FormViewController, HasForm {
	
	override func buildForm(with formAttrs: FormAttributes) {
		super.buildForm(with: formAttrs)
		//Updates all data sources
		update()
		update(with: formAttrs)
		//Reload table and optionally scroll to cell that's not validated
		reloadAndScroll()
	}
	
	var first: First = {
		var first = First(
			name: "",
			description: "description",
			otherNames: "otherNames",
			address: "",
			categoryId: 0,
			point: [],
			videos: [],
			photos: [])
		return first
	}()
	
	
	func validated(_ fullForm: FullForm) -> FullForm? {
		update(isAfterValidation: true)
		//update(with: formAttrs)
		reloadAndScroll()
		
		let hasUnfilledRow = validatables.firstIndex(where: { $0?.canShowRedAlert ?? false })
		return evaluate(hasUnfilledRow != nil, ifTrue: nil, ifFalse: fullForm)
	}
	
	var form: FullForm? {

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
		
		return validated(form)
	}	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	private func setup() {
		tableView.register(cellClass: TextFormCell.self)
		tableView.register(cellClass: SubSectionHeaderCell.self)
		genInfoSectionSource = FormTableViewDataSource(l10n(.genInfo))
		dataSource = SectionedTableViewDataSource(dataSources: [genInfoSectionSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	//MARK: - Update methods
	
	var validatables = [Validatable?]()
	
	private func updateValidatables(with configurators: [CellConfiguratorType]) {
		validatables = configurators.map { $0.validatable }
	}
	
	private func reloadAndScroll() {
		tableView.reloadData()
		if let firstUnfilledRow = validatables.firstIndex(where: { $0?.canShowRedAlert ?? false }) {
			tableView.scrollToRow(at: IndexPath(row: firstUnfilledRow, section: 0), at: .top, animated: true)
		}
	}
	
	private func update(with formAttrs: FormAttributes ,isAfterValidation: Bool = false) {
		//MARK: - Parking Section
		let parkings = formAttrs.full.entrance
		
		var cellsProps = [Any]()
		//begin loop
		parkings.forEach { group in
			
			if let groupTitle  = group.title {
				let titleCellProps = Header(title: groupTitle)
				cellsProps.append(titleCellProps)
			}
			
			group.subGroups?.forEach { subGroup in
				
				if let subGroupTitle = subGroup.title {
					let titleCellProps = Header(title: subGroupTitle, fontSize: 12)
					cellsProps.append(titleCellProps)
				}
				
				subGroup.attributes?.forEach { attribute in
					let cellProps = TextFormCell.Props(
						text: "",
						title: attribute.finalTitle,
						overlay: "chevron_down",
						mode: .onlyTextField,
						onEditText: Text { print($0) }
					)
					cellsProps.append(cellProps)
				}
			}
		}
		//end loop
		
		let configurators: [CellConfiguratorType] = cellsProps.map {
			if let textCellProps = $0 as? TextFormCell.Props {
				return CellConfigurator<TextFormCell>(props: textCellProps)
			} else {
				return CellConfigurator<SubSectionHeaderCell>(props: $0 as! Header)
			}
		}
		
		let parkingDataSource = FormTableViewDataSource("Parking", configurators)
		dynamicDataSources.append(parkingDataSource)
		dataSource.replaceDatasources(with: [genInfoSectionSource] + dynamicDataSources)
		
		updateValidatables(with: configurators)
	}
	
	private func update(isAfterValidation: Bool = false) {
		
		func shouldBeRed(_ condition: Bool) -> Bool {
			return condition && isAfterValidation
		}
		
		let objectName = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(first.name.isEmpty),
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
		
		updateValidatables(with: configurators)
	}
	
	//MARK: - Section Data Sources
	private var dataSource: SectionedTableViewDataSource!
	
	private var genInfoSectionSource: FormTableViewDataSource!
	
	private var dynamicDataSources = [FormTableViewDataSource]()

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
