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
}

class ComplaintViewController: TableViewController, ComplaintViewInput, UITableViewDelegate {
	
	var output: ComplaintViewOutput!
	
	//MARK: - ComplaintViewInput fields
	func setupInitialState() {
		setupTable()
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
	
	var familyName = ""
	
	//MARK: - Table view "update dataSources" methods
	
	private func update(isAfterValidation: Bool = false) {
		func shouldBeRed(_ condition: Bool) -> Bool {
			return condition && isAfterValidation
		}
		
		let familyNameProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(familyName.isEmpty),
			text: familyName,
			title: l10n(.familyName),
			mode: .onlyTextField,
			onEditText: Text {
				self.familyName = $0
				self.update()
			}
		)
	
		personalInfoDataSource.configurators = [
			CellConfigurator<TextFormCell>(props: familyNameProps)
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
//		if let firstUnfilledRow = validatables.firstIndex(where: { $0?.canShowRedAlert ?? false }) {
//			tableView.scrollToRow(at: IndexPath(row: firstUnfilledRow, section: 0), at: .top, animated: true)
//		}
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
