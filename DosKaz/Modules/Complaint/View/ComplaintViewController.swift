//
//  ComplaintViewController.swift
//  Complaint
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-21 07:01:46 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework

// MARK: View input protocol

protocol ComplaintViewInput: DisplaysAlert where Self: UIViewController {
	func setupInitialState()
	func showInitial(_ complaintData: ComplaintData, _ cities: [City], _ auths:[Authority], _ complaintAtrs: [ComplaintAtr])
	var onTouchReady: CommandWith<ComplaintData> { get set }
	var onPickImage: CommandWith<UIImage> { get set }
}

class ComplaintViewController: TableViewController, ComplaintViewInput, UITableViewDelegate {
	
	var output: ComplaintViewOutput!
	
	//MARK: - ComplaintViewInput fields
	
	func isValid() -> Bool {
		updateSectionOneDataSource(isAfterValidation: true)
		updateSectionTwoDataSource(isAfterValidation: true)
		updateValsForSectionOne()
		updateValsForSectionTwo()
		dataSource.openAll()
		reload(with: .all)
		scrollToInvalidRow()
		let fv = firstSectionValidatables.firstIndex(where: { $0?.canShowRedAlert ?? false })
		let sv = secondSectionValidatables.firstIndex(where: { $0?.canShowRedAlert ?? false })
		return (fv == nil) && (sv == nil)
	}
	
	@objc func formDone() {
		//fake
		
		
		complaintData.objectId = nil
		
		//fake
		
		guard isValid() else { return }
		
		complaintData.complainant.cityId = currentCity?.id
		complaintData.content.cityId = currentObjectCity?.id
		complaintData.authorityId = currentAuth?.id
		complaintData.content.type = currentComplaintType.rawValue
		onTouchReady.perform(with: complaintData)
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
	
	var onTouchReady: CommandWith<ComplaintData> = .nop
	
	var onPickImage: CommandWith<UIImage> = .nop
	
	func setupInitialState() {
		navigationItem.title = l10n(.complainSimply)
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: l10n(.close), style: .plain, target: self, action: #selector(close))
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: l10n(.done), style: .done,
			target: self, action: #selector(formDone)
		)
		setupTable()

	}
	
	func showInitial(_ complaintData: ComplaintData, _ cities: [City], _ auths:[Authority], _ complaintAtrs: [ComplaintAtr]) {
		self.auths = auths
		self.cities = cities
		self.complaintData = complaintData
		self.complaintAtrs = complaintAtrs
		
		currentCity = cities.first(where: { $0.id == complaintData.complainant.cityId })
		currentObjectCity = cities.first(where: { $0.id == complaintData.content.cityId })
		currentAuth = auths.first(where: { $0.id == complaintData.authorityId })
		
		updateSectionOneDataSource()
		updateSectionTwoDataSource()
		switch currentComplaintType {
		case .complaint1:
			break
		case .complaint2:
			updateDynamicDataSources()
		}
		updateLastSectionDataSource()
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
		tableView.register(cellClass: RightCheckCell.self)
		tableView.register(cellClass: PhotoPickerCell.self)
		tableView.register(cellClass: TextCell.self)
		tableView.register(cellClass: TextViewCell.self)
		
		personalInfoDataSource = FormTableViewDataSource(l10n(.personalInfo))
		complaintDataSource = FormTableViewDataSource(l10n(.complaint))
		otherSectionDataSource = FormTableViewDataSource(l10n(.other))
		lastSectionDataSource = FormTableViewDataSource(l10n(.additional))
		dataSource = SectionedTableViewDataSource(dataSources: [personalInfoDataSource, complaintDataSource, lastSectionDataSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	//MARK: - Table view data sources
	
	private var dataSource: SectionedTableViewDataSource!
	
	private var personalInfoDataSource: FormTableViewDataSource!
	
	private var complaintDataSource: FormTableViewDataSource!
	
	private var otherSectionDataSource: FormTableViewDataSource!
	
	private var lastSectionDataSource: FormTableViewDataSource!
	
	//MARK: - Lists for particular fields
	
	var cities = [City]()
	
	var auths = [Authority]()
	
	var complaintAtrs = [ComplaintAtr]()
	
	//MARK: - Source of data for table view dataSource instances
	
	var currentComplaintType = ComplaintType.complaint1
	
	var currentCity: City?
	
	var currentObjectCity: City?
	
	var currentAuth: Authority?
	
	var complaintData: ComplaintData!
	
	var dynamicSections = [String: [String: Bool]]()
	
	private var images = [UIImage]()
	
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
			mode: .onlyTextField,
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
		
		let buildingProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.building).isEmpty),
			text: value(person.building),
			title: l10n(.building),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.building = $0
				self.updateSectionOneDataSource()
			}
		)
		
		let apartmentProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(person.apartment).isEmpty),
			text: value(person.apartment),
			title: l10n(.apartment),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.complainant.apartment = $0
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
			},
			formatter: { PhoneFormatter.format(phoneNumber: $0) }
		)
		
		let authProps = TextFormCell.Props(
			shouldEdit: false,
			text: value(currentAuth?.name),
			title: l10n(.authority),
			overlay: "chevron_down",
			mode: .onlyTextField,
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentAuth = $0
						self.updateSectionOneDataSource()
						self.reload(with: .rows([9], 0))
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
				self.reload(with: .rows([10], 0))
			}
		)
	
		personalInfoDataSource.configurators = [
			CellConfigurator<TextFormCell>(props: familyNameProps),
			CellConfigurator<TextFormCell>(props: firstNameProps),
			CellConfigurator<TextFormCell>(props: middleNameProps),
			CellConfigurator<TextFormCell>(props: iinProps),
			CellConfigurator<TextFormCell>(props: cityProps),
			CellConfigurator<TextFormCell>(props: streetProps),
			CellConfigurator<TextFormCell>(props: buildingProps),
			CellConfigurator<TextFormCell>(props: apartmentProps),
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
			mode: .onlyTextField,
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentComplaintType = $0
						self.updateSectionTwoDataSource()
						self.updateDynamicDataSources()
						self.reload(with: .all)
					},
					currentValue: self.currentComplaintType,
					choices: ComplaintType.allCases
				)
			}
		)
		
		let dateProps = TextFormCell.Props(
			shouldEdit: false,
			canShowRedAlert: shouldBeRed(value(content.visitedAt.full).isEmpty),
			text: content.visitedAt.full,
			title: l10n(.dateOfVisit),
			overlay: "calendar",
			mode: .onlyTextField,
			onOverlayTouch: Command { [weak self] in
				self?.pick(with: OnPick<Date> { [weak self] in
					self?.complaintData.content.visitedAt = $0
					self?.updateSectionTwoDataSource()
					self?.reload(with: .rows([1], 1))
				})
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
			mode: .onlyTextField,
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
		
		let objectBuildingProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(content.building).isEmpty),
			text: value(content.building),
			title: l10n(.objectBuildingNumber),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.content.building = $0
				self.updateSectionTwoDataSource()
			}
		)
		
		let objectOfficeProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(content.office).isEmpty),
			text: value(content.office),
			title: l10n(.objectOfficeNumber),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.content.office = $0
				self.updateSectionTwoDataSource()
			}
		)
		
		let visitPurposeProps = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(value(content.visitPurpose).isEmpty),
			text: value(content.visitPurpose),
			title: l10n(.visitPurpose),
			mode: .onlyTextField,
			onEditText: Text {
				self.complaintData.content.visitPurpose = $0
				self.updateSectionTwoDataSource()
			}
		)
		
		complaintDataSource.configurators = [
			CellConfigurator<TextFormCell>(props: complaintTypeProps),
			CellConfigurator<TextFormCell>(props: dateProps),
			CellConfigurator<TextFormCell>(props: objectNameProps),
			CellConfigurator<TextFormCell>(props: objectCityProps),
			CellConfigurator<TextFormCell>(props: objectStreetProps),
			CellConfigurator<TextFormCell>(props: objectBuildingProps),
			CellConfigurator<TextFormCell>(props: objectOfficeProps),
			CellConfigurator<TextFormCell>(props: visitPurposeProps),
		]
		
		let textProps = TextCell.Props(title: l10n(.complaint2Header), isBlue: true)

		let config = CellConfigurator<TextCell>(props: textProps)
		if case ComplaintType.complaint2 = currentComplaintType {
			complaintDataSource.configurators.append(config)
		}
		
	}
	
	private func updateDynamicDataSources(isAfterValidation: Bool = false) {
		
		func shouldBeRed(_ condition: Bool) -> Bool {
			return condition && isAfterValidation
		}
		
		let localDynamicDataSources: [FormTableViewDataSource] = complaintAtrs.map { section in
			
			if !dynamicSections.keys.contains(section.key) {
				dynamicSections[section.key] = [String: Bool]()
			}
			
			let configs: [CellConfiguratorType] = section.options.map { option in
				
				if self.dynamicSections[section.key]?[option.key] == nil {
					self.dynamicSections[section.key]?[option.key] = false
				}
				
				let props = RightCheckCell.Props(
					title: option.label,
					isChecked: self.dynamicSections[section.key]?[option.key] ?? false,
					onTap: Command {
						self.self.dynamicSections[section.key]?[option.key]?.toggle()
						self.updateDynamicDataSources()
						self.reload(with: .all)
					}
				)
				return CellConfigurator<RightCheckCell>(props: props)
			}
	
			let source = FormTableViewDataSource(section.title, configs)
			return source
		}
		
		let commentsProps = TextViewCell.Props(
			canShowRedAlert: shouldBeRed(complaintData.content.comment.isEmpty),
			title: l10n(.yourComments),
			placeHolder: l10n(.textOftheMessage),
			text: complaintData.content.comment,
			onEditText: Text {
				self.complaintData.content.comment = $0
				self.updateSectionOneDataSource()
			}
		)
		
		
		let lifeThreatProps = LeftCheckCell.Props(
			title: l10n(.lifeThreat),
			isChecked: complaintData.content.threatToLife,
			onTap: Command {
				self.complaintData.content.threatToLife.toggle()
				self.updateDynamicDataSources()
				self.reload(with: .all)
		})
	
		otherSectionDataSource.configurators = [
			CellConfigurator<TextViewCell>(props: commentsProps),
			CellConfigurator<LeftCheckCell>(props: lifeThreatProps)
		]

		var type1Sources: [FormTableViewDataSource] = [FormTableViewDataSource]()
		type1Sources.append(personalInfoDataSource)
		type1Sources.append(complaintDataSource)
		type1Sources.append(contentsOf: localDynamicDataSources)
		type1Sources.append(otherSectionDataSource)
		type1Sources.append(lastSectionDataSource)
		
		var type2Sources: [FormTableViewDataSource] = [FormTableViewDataSource]()
		type2Sources.append(personalInfoDataSource)
		type2Sources.append(complaintDataSource)
		type2Sources.append(lastSectionDataSource)
		
		if case ComplaintType.complaint2 = currentComplaintType {
			dataSource.replaceDatasources(with: type1Sources)
		} else {
			dataSource.replaceDatasources(with: type2Sources)
		}
	}
	
	private func updateLastSectionDataSource() {
		let photoProps = PhotoPickerCell.Props(
			images: images,
			onPick: Command {
				let picker = UIImagePickerController()
				picker.delegate = self
				self.present(picker, animated: true)
			}
		)
		let photoConfig = CellConfigurator<PhotoPickerCell>(props: photoProps )

		lastSectionDataSource.configurators = videoLinks + [photoConfig]
	}
	
	private var videoLinks: [CellConfigurator<TextFormCell>] {
		
		let videos = complaintData.content.videos
		
		var links: [TextFormCell.Props] = videos.enumerated().map { (index, link) in
			return TextFormCell.Props(
				text: link,
				title: l10n(.videoLink),
				mode: .full(icon: "x_in_form"),
				onRightTouch: Text { _ in
					self.complaintData.content.videos.remove(atValid: index)
					self.updateLastSectionDataSource()
					self.reload(with: .all)
				},
				onEditText: Text {
					self.complaintData.content.videos.update(with: $0, at: index)
					self.updateLastSectionDataSource()
				}
			)
		}
		
		let emptyLinkCell = TextFormCell.Props(
			text: "",
			title: l10n(.videoLink),
			mode: .full(icon: "plus_in_form"),
			onRightTouch: Text { newText in
				guard !newText.isEmpty else { return }
				self.complaintData.content.videos.append(newText)
				self.updateLastSectionDataSource()
				self.reload(with: .all)
			},
			onEditText: Text { print($0) }
		)
		
		links.append(emptyLinkCell)
		
		let cells = links.map { CellConfigurator<TextFormCell>(props: $0)}
		return cells
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
	
	}
	
	//MARK: - Validation
	var firstSectionValidatables = [Validatable?]()
	var secondSectionValidatables = [Validatable?]()
		
	private func updateValsForSectionOne()  {
		let validatables: [Validatable?] = personalInfoDataSource.configurators.map { $0.validatable }
		firstSectionValidatables  = validatables
	}
	
	private func updateValsForSectionTwo() {
		let validatables: [Validatable?] = complaintDataSource.configurators.map { $0.validatable }
		secondSectionValidatables = validatables
	}
	
	private func scrollToInvalidRow() {
		if let firstInvalidRow = firstSectionValidatables.firstIndex(where: { $0?.canShowRedAlert ?? false }) {
			let fr = IndexPath(row: firstInvalidRow, section: 0)
			if firstInvalidRow <= tableView.numberOfRows(inSection: 0) {
				tableView.scrollToRow(at: fr , at: .top, animated: true)
			}
		} else if let firstInvalidRow = secondSectionValidatables.firstIndex(where: { $0?.canShowRedAlert ?? false }) {
			let fr = IndexPath(row: firstInvalidRow, section: 1)
			if firstInvalidRow <= tableView.numberOfRows(inSection: 1) {
				tableView.scrollToRow(at:  fr, at: .top, animated: true)
			}
		}
	}
	
	//MARK: - Table view section header
	
	private func count(for tableSection: Int) -> Int? {
		
		let section = tableSection - 2
		guard complaintAtrs.indices.contains(section) else {
			return nil
		}
		
		let atr = complaintAtrs[section]
		let sectionKey = atr.key
		guard let sectionRows = dynamicSections[sectionKey] else {
			return nil
		}
		
		let count = sectionRows.values.filter { $0 == true }.count
		
		guard count != 0 else {
			return nil
		}
		
		return count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = dataSource.titles[section].uppercased()
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell") as? HeaderCell
		header?.props = HeaderCell.Props(
			isOpen: dataSource.openBook[section] ?? true,
			count: count(for: section),
			title: title,
			fontSize: 13,
			section: section,
			onTap: CommandWith<Int> { section in
				self.dataSource.openBook[section]?.toggle()
				self.reload(with: .sections([section]))
//
//				var nextSection = section
//				repeat {
//					nextSection = nextSection + 1
//				} while self.dataSource.openBook[nextSection]! == false
//
//				if nextSection >= tableView.numberOfSections {
//					nextSection = (section - 1) < 0 ? section : (section - 1)
//				}
//
//				self.scrollTo(section: section, nextOpenSection: nextSection)
//
			}
		)
		return header
	}
	
	func scrollTo(section: Int, nextOpenSection: Int) {
		
		guard section < tableView.numberOfSections else {
			return
		}

		if tableView.numberOfRows(inSection: section) > 0  {
			print("Opening")
			let indexPath = IndexPath(row: 0, section: section)
			tableView.scrollToRow(at: indexPath, at: .top, animated: false)
			
			let rect = self.tableView.rectForHeader(inSection: section)
			tableView.scrollRectToVisible(rect, animated: false)
			
		} else {
			print("Closing")
			print("Nexopen:", nextOpenSection)
			let indexPath = IndexPath(row: 0, section: nextOpenSection)
			tableView.scrollToRow(at: indexPath, at: .top, animated: false)
			
			let rect = self.tableView.rectForHeader(inSection: section)
			tableView.scrollRectToVisible(rect, animated: false)
		}

	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
}

extension ComplaintViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		images.append(image)
		updateLastSectionDataSource()
		reload(with: .all)
		onPickImage.perform(with: image)
		dismiss(animated: true)
	}
}

extension ComplaintViewController {
	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
		addHeaderView()
	}
	
	func addHeaderView() {
		let label = UILabel()
		label.text = l10n(.complaintHeader)
		label.numberOfLines = 0
		let headerView = UIView()
		headerView.addSubview(label)
		label.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24))
		tableView.tableHeaderView = headerView
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		sizeHeaderToFit(tableView: tableView)
	}
	
	func sizeHeaderToFit(tableView: UITableView) {
		if let headerView = tableView.tableHeaderView {
			let height = headerView.systemLayoutSizeFitting(
				CGSize(width: tableView.frame.width, height: 100),
				withHorizontalFittingPriority: .defaultHigh,
				verticalFittingPriority: .fittingSizeLevel
			).height
			
			if headerView.frame.size.height != height {
				headerView.frame.size.height = height
				tableView.tableHeaderView = headerView
			}
		}
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
