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
	func showInitial(_ complaintData: ComplaintData)
}

class ComplaintViewController: TableViewController, ComplaintViewInput, UITableViewDelegate {
	
	var output: ComplaintViewOutput!
	
	//MARK: - ComplaintViewInput fields
	func setupInitialState() {
		setupTable()

	}
	
	func showInitial(_ complaintData: ComplaintData) {
		self.complaintData = complaintData
		update()
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
		
		personalInfoDataSource = FormTableViewDataSource(l10n(.personalInfo))
		dataSource = SectionedTableViewDataSource(dataSources: [personalInfoDataSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	//MARK: - Table view data sources
	
	private var dataSource: SectionedTableViewDataSource!
	
	private var personalInfoDataSource: FormTableViewDataSource!
	
	//MARK: - Source of data for table view dataSource instances
	
	var complaintData: ComplaintData!
	
	//MARK: - Table view "update dataSources" methods
	
	private func update(isAfterValidation: Bool = false) {
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
				self.update()
			}
		)
		
		let firstNameProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.firstName).isEmpty),
			text: value(person.firstName),
			title: l10n(.firstName),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.firstName = $0
				self.update()
			}
		)

		let middleNameProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.middleName).isEmpty),
			text: value(person.middleName),
			title: l10n(.middleName),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.middleName = $0
				self.update()
			}
		)
		
		let iinProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.iin).isEmpty),
			text: value(person.iin),
			title: l10n(.iin),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.iin = $0
				self.update()
			}
		)
		
		let streetProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.street).isEmpty),
			text: value(person.street),
			title: l10n(.street),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.street = $0
				self.update()
			}
		)
	
		personalInfoDataSource.configurators = [
			CellConfigurator<TextFormCell>(props: familyNameProps),
			CellConfigurator<TextFormCell>(props: firstNameProps),
			CellConfigurator<TextFormCell>(props: middleNameProps),
			CellConfigurator<TextFormCell>(props: iinProps),
			CellConfigurator<TextFormCell>(props: streetProps),
		]
	}
	
	//MARK: - Table view RELOAD methods
	
	private func reload(with type: Reload, animated: Bool = true) {
		switch type {
		case .rows(let rows, let section):
			let indexPaths = rows.map { IndexPath(row: $0, section: section)}
			tableView.reloadRows(at: indexPaths, with: .left)
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
