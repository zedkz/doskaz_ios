//
//  ComplaintViewController.swift
//  Complaint
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-21 07:01:46 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework

// MARK: View input protocol

protocol ComplaintViewInput where Self: UIViewController {
	func setupInitialState()
	func showInitial(_ complaintData: ComplaintData, _ cities: [City], _ auths:[Authority])
}

class ComplaintViewController: TableViewController, ComplaintViewInput, UITableViewDelegate {
	
	var output: ComplaintViewOutput!
	
	//MARK: - ComplaintViewInput fields
	func setupInitialState() {
		setupTable()

	}
	
	func showInitial(_ complaintData: ComplaintData, _ cities: [City], _ auths:[Authority]) {
		self.auths = auths
		self.cities = cities
		self.complaintData = complaintData
		updateSectionOneDataSource()
		updateSectionTwoDataSource()
		reload(with: .all)
	}

	//MARK: - Private
	
	private func setupTable() {
		tableView.tableFooterView = UIView()
		tableView.keyboardDismissMode = .interactive
		tableView.separatorStyle = .none
		
		tableView.register(HeaderCell.self, forHeaderFooterViewReuseIdentifier: "HeaderCell")
		tableView.register(cellClass: TextFormCell.self)
		tableView.register(cellClass: SubSectionHeaderCell.self)
		tableView.register(cellClass: PhotoPickerCell.self)
		tableView.register(cellClass: LeftCheckCell.self)
		
		personalInfoDataSource = FormTableViewDataSource(l10n(.personalInfo))
		complaintDataSource = FormTableViewDataSource(l10n(.complaint))
		dataSource = SectionedTableViewDataSource(dataSources: [personalInfoDataSource, complaintDataSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	//MARK: - Table view data sources
	
	private var dataSource: SectionedTableViewDataSource!
	
	private var personalInfoDataSource: FormTableViewDataSource!
	
	private var complaintDataSource: FormTableViewDataSource!
	
	//MARK: - Lists for particular fields
	
	var cities = [City]()
	
	var auths = [Authority]()
	
	//MARK: - Source of data for table view dataSource instances
	
	var currentComplaintType = ComplaintType.complaint1
	
	var currentCity: City?
	
	var currentObjectCity: City?
	
	var currentAuth: Authority?
	
	var complaintData: ComplaintData!
	
	//MARK: - Table view "update dataSources" methods
	
	private func updateSectionOneDataSource(isAfterValidation: Bool = false) {
		func shouldBeRed(_ condition: Bool) -> Bool {
			return condition && isAfterValidation
		}
		
		func value(_ value: String?) -> String {
			return value ?? ""
		}
		
		let person = complaintData.complainant
		
		let familyNameProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.lastName).isEmpty),
			text: value(person.lastName),
			title: l10n(.familyName),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.lastName = $0
				self.updateSectionOneDataSource()
			}
		)
		
		let firstNameProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.firstName).isEmpty),
			text: value(person.firstName),
			title: l10n(.firstName),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.firstName = $0
				self.updateSectionOneDataSource()
			}
		)

		let middleNameProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.middleName).isEmpty),
			text: value(person.middleName),
			title: l10n(.middleName),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.middleName = $0
				self.updateSectionOneDataSource()
			}
		)
		
		let iinProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.iin).isEmpty),
			text: value(person.iin),
			title: l10n(.iin),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.iin = $0
				self.updateSectionOneDataSource()
			}
		)
		
		let cityProps = TextFormCell.Props(
			shouldEdit: false,
			text: value(currentCity?.name),
			title: l10n(.city),
			overlay: "chevron_down",
			mode: .withoutButton,
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentCity = $0
						self.updateSectionOneDataSource()
						self.reload(with: .rows([4], 0))
					},
					currentValue: self.currentCity,
					choices: self.cities
				)
			}
		)
		
		let streetProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.street).isEmpty),
			text: value(person.street),
			title: l10n(.street),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.street = $0
				self.updateSectionOneDataSource()
			}
		)
		
		let phoneProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.phone).isEmpty),
			text: value(person.phone),
			title: l10n(.phone),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.phone = $0
				self.updateSectionOneDataSource()
			}
		)
		
		let authProps = TextFormCell.Props(
			shouldEdit: false,
			text: value(currentAuth?.name),
			title: l10n(.authority),
			overlay: "chevron_down",
			mode: .withoutButton,
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentAuth = $0
						self.updateSectionOneDataSource()
						self.reload(with: .rows([8], 0))
					},
					currentValue: self.currentAuth,
					choices: self.auths
				)
			}
		)
		
		let rememberDataProps = LeftCheckCell.Props(
			title: l10n(.rememberMyData),
			isChecked: complaintData.rememberPersonalData,
			onTap: Command {
				self.complaintData.rememberPersonalData.toggle()
				self.updateSectionOneDataSource()
				//TODO: -update rows
				self.reload(with: .rows([9], 0))
			}
		)
	
		personalInfoDataSource.configurators = [
			CellConfigurator<TextFormCell>(props: familyNameProps),
			CellConfigurator<TextFormCell>(props: firstNameProps),
			CellConfigurator<TextFormCell>(props: middleNameProps),
			CellConfigurator<TextFormCell>(props: iinProps),
			CellConfigurator<TextFormCell>(props: cityProps),
			CellConfigurator<TextFormCell>(props: streetProps),
			CellConfigurator<TextFormCell>(props: phoneProps),
			CellConfigurator<TextFormCell>(props: authProps),
			CellConfigurator<LeftCheckCell>(props: rememberDataProps)
		]
	}
	
	private func updateSectionTwoDataSource(isAfterValidation: Bool = false) {
		func shouldBeRed(_ condition: Bool) -> Bool {
			return condition && isAfterValidation
		}
		
		func value(_ value: String?) -> String {
			return value ?? ""
		}
		
		let content = complaintData.content
		
		let complaintTypeProps = TextFormCell.Props(
			shouldEdit: false,
			text: currentComplaintType.description,
			title: l10n(.complaintType),
			overlay: "chevron_down",
			mode: .withoutButton,
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentComplaintType = $0
						self.updateSectionTwoDataSource()
						self.reload(with: .rows([0], 1))
					},
					currentValue: self.currentComplaintType,
					choices: ComplaintType.allCases
				)
			}
		)
		
		let objectNameProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(content.objectName).isEmpty),
			text: value(content.objectName),
			title: l10n(.objectName),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.content.objectName = $0
				self.updateSectionTwoDataSource()
			}
		)
		
		let objectCityProps = TextFormCell.Props(
			shouldEdit: false,
			text: value(currentObjectCity?.name),
			title: l10n(.city),
			overlay: "chevron_down",
			mode: .withoutButton,
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentObjectCity = $0
						self.updateSectionTwoDataSource()
						self.reload(with: .rows([3], 1))
					},
					currentValue: self.currentObjectCity,
					choices: self.cities
				)
			}
		)
		
		let objectStreetProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(content.street).isEmpty),
			text: value(content.street),
			title: l10n(.street),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.content.street = $0
				self.updateSectionTwoDataSource()
			}
		)
		
		complaintDataSource.configurators = [
			CellConfigurator<TextFormCell>(props: complaintTypeProps),
			CellConfigurator<TextFormCell>(props: objectNameProps),
			CellConfigurator<TextFormCell>(props: objectCityProps),
			CellConfigurator<TextFormCell>(props: objectStreetProps),
		]
	}
	
	//MARK: - Table view RELOAD methods
	
	private func reload(with type: Reload, animated: Bool = true) {
		switch type {
		case .rows(let rows, let section):
			let indexPaths = rows.map { IndexPath(row: $0, section: section)}
			tableView.reloadRows(at: indexPaths, with: .automatic)
		case .sections(let sections):
			if animated {
				tableView.reloadSections(IndexSet(sections), with: .automatic)
			} else {
				UIView.performWithoutAnimation {
					tableView.reloadSections(IndexSet(sections), with: .automatic)
				}
			}
		case .all:
			tableView.reloadData()
		}
		
		scrollToInvalidRow()
	}
	
	//MARK: - Validation
		
	private func firstSectionInvalidRow() -> IndexPath?  {
		let configurators = personalInfoDataSource.configurators
		let validatables = configurators.map { $0.validatable }
		guard let firstInvalidRow = validatables.firstIndex(where: { $0?.canShowRedAlert ?? false }) else {
			return nil
		}
		return IndexPath(row: firstInvalidRow, section: 0)
	}
	
	private func scrollToInvalidRow() {
		var invalidRows = [IndexPath]()
		if let row = firstSectionInvalidRow() {
			invalidRows.append(row)
		}
		if let first = invalidRows.first {
			tableView.scrollToRow(at: first , at: .top, animated: true)
		}
	}
	
	//MARK: - Table view section header
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = dataSource.titles[section].uppercased()
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell") as? HeaderCell
		header?.props = HeaderCell.Props(title: title, fontSize: 13, section: section, onTap: CommandWith<Int> { section in
			self.dataSource.openBook[section]?.toggle()
			self.reload(with: .sections([section]))
		})
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
}

extension ComplaintViewController {
	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}
}

enum Reload {
	case rows([Int], Int)
	case sections([Int])
	case all
}

enum ComplaintType: String, CustomStringConvertible, CaseIterable {
	case complaint1
	case complaint2
	
	var description: String {
		switch self {
		case .complaint1:
			return l10n(.complaintTypeOne)
		case .complaint2:
			return l10n(.complaintTypeTwo)
		}
	}
}
