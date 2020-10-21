//
//  FormControllers.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework
import UIKit

class FormViewController: TableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableFooterView = UIView()
		tableView.keyboardDismissMode = .interactive
		tableView.separatorStyle = .none
	}
	
	func buildForm(with formAttrs: FormAttributes, and categories: [Category] ) {
		print("Super's implementation of build form")
	}
}

//MARL: - Type that produces form
protocol HasForm {
	var form: FullForm? { get }
}


//MARK: - SmallFormViewController

class SmallFormViewController: FormViewController, HasForm {
	
	override func buildForm(with formAttrs: FormAttributes, and categories: [Category] ) {
		super.buildForm(with: formAttrs, and: categories)
		//Updates all data sources
		self.categories = categories
		self.formAttrs = formAttrs
		update()
		update(with: formAttrs)
		//Reload table and optionally scroll to cell that's not validated
		reloadAndScroll()
	}
	
	var formType: FormType! {
		didSet {
			if let formAttrs = formAttrs {
				update(with: formAttrs)
				reloadAndScroll()
			}
		}
	}
	
	var categories = [Category]()
	var formAttrs: FormAttributes!
	
	var currentCategory: Category?
	var currentSub: Category?
	
	var allSections = [String: [String: FormValue]]()
	
	private var images = [UIImage]()
	
	var onPickImage: CommandWith<UIImage> = .nop
	
	var onTypeVenue: CommandWith<PotentialVenue> = .nop
	
	func typeVenue() {
		let venue = PotentialVenue(name: first.name, otherNames: first.otherNames)
		onTypeVenue.perform(with: venue)
	}
	
	var first: First = {
		var first = First(
			name: "",
			description: "",
			otherNames: "",
			address: "",
			categoryId: 0,
			point: [52.25,76.94],
			videos: [],
			photos: [])
		return first
	}()
	
	var isValidating = false
	
	func validated(_ fullForm: FullForm) -> FullForm? {
		isValidating = true
		update()
		reloadAndScroll()
		
		let hasUnfilledRow = validatables.firstIndex(where: { $0?.canShowRedAlert ?? false })
		return evaluate(hasUnfilledRow != nil, ifTrue: nil, ifFalse: fullForm)
	}
	
	var form: FullForm? {
		
		first.categoryId = currentSub?.id ?? 0
		
		let parking = FormSection(
			attributes: allSections[l10n(.parking)] ?? [:],
			comment: "dsf"
		)
		
		let entrance1 = FormSection(
			attributes: allSections[l10n(.entrance)] ?? [:],
			comment: "dsf"
		)
		
		let movement = FormSection(
			attributes: allSections[l10n(.movement)] ?? [:],
			comment: "dsf"
		)
		
		let service = FormSection(
			attributes: allSections[l10n(.service)] ?? [:],
			comment: "dsf"
		)
		
		let toilet = FormSection(
			attributes: allSections[l10n(.toilet)] ?? [:],
			comment: "dsf"
		)
		let navigation = FormSection(
			attributes: allSections[l10n(.navigation)] ?? [:],
			comment: "dsf"
		)
		
		let serviceAccessibility = FormSection(
			attributes: allSections[l10n(.serviceAccessibility)] ?? [:],
			comment: "dsf"
		)
				
		let form = FullForm(
			form: "small",
			first: first,
			parking: parking,
			entrance1: entrance1,
			movement: movement,
			service: service,
			toilet: toilet,
			navigation: navigation,
			serviceAccessibility: serviceAccessibility
		)
		
		if let validated = validated(form) {
			isValidating = false
			return validated
		}
		
		return nil
	}	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	private func setup() {
		tableView.register(HeaderCell.self, forHeaderFooterViewReuseIdentifier: "HeaderCell")
		tableView.register(cellClass: TextFormCell.self)
		tableView.register(cellClass: SubSectionHeaderCell.self)
		tableView.register(cellClass: PhotoPickerCell.self)
		tableView.register(cellClass: TextViewCell.self)
		genInfoSectionSource = FormTableViewDataSource(l10n(.genInfo))
		dataSource = SectionedTableViewDataSource(dataSources: [genInfoSectionSource])
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	//MARK: - Update methods
	
	// Add second set of these
	var validatables = [Validatable?]()
	
	private func updateValidatables(with configurators: [CellConfiguratorType]) {
		validatables = configurators.map { $0.validatable }
	}
	
	private func reloadAndScroll(_ rows: [Int]? = nil, _ section: Int? = nil) {
		if let rows = rows, let section = section {
			let indexPaths = rows.map { IndexPath(row: $0, section: section)}
			tableView.reloadRows(at: indexPaths, with: .left)
		} else if let section = section {
			UIView.performWithoutAnimation {
				tableView.reloadSections([section], with: .none)
			}
		} else {
			tableView.reloadData()
		}
		if let firstUnfilledRow = validatables.firstIndex(where: { $0?.canShowRedAlert ?? false }) {
			tableView.scrollToRow(at: IndexPath(row: firstUnfilledRow, section: 0), at: .top, animated: true)
		}
	}
	
	private func update(with formAttrs: FormAttributes) {

		var localDynamicDataSources = [FormTableViewDataSource]()
		func addSection(for groups: [Group], title: String, section: Int) {
			let configurators = cellConfigurators(from: groups, title: title, section: section)
			let dataSource = FormTableViewDataSource(title, configurators)
			localDynamicDataSources.append(dataSource)
		}
		
		var value: Full {
			switch self.formType {
			case .small: return formAttrs.small
			case .middle: return formAttrs.middle
			case .full: return formAttrs.full
			case .none: return formAttrs.small
			}
		}
		
		let formType = value
		
		//MARK: - Parking Section
		addSection(for: formType.parking, title: l10n(.parking), section: 1)
		
		//MARK: - Entrance 1
		addSection(for: formType.entrance, title: l10n(.entrance), section: 2)

		//MARK: - Movement
		addSection(for: formType.movement, title: l10n(.movement), section: 3)
		
		//MARK: - Service
		addSection(for: formType.service, title: l10n(.service), section: 4)
		
		//MARK: - Toilet
		addSection(for: formType.toilet, title: l10n(.toilet), section: 5)
		
		//MARK: - Navigation
		addSection(for: formType.navigation, title: l10n(.navigation), section: 6)
		
		//MARK: - Service accessibility
		addSection(for: formType.serviceAccessibility, title: l10n(.serviceAccessibility), section: 7)
		
		//MARK: - Update main datasource
		dataSource.replaceDatasources(with: [genInfoSectionSource] + localDynamicDataSources)
		
	}
	
	private func update() {
		
		func shouldBeRed(_ condition: Bool) -> Bool {
			return condition && self.isValidating
		}
		
		let objectName = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(first.name.isEmpty),
			text: first.name,
			title: l10n(.objName),
			mode: .full(icon: "help_in_form"),
			onEditText: Text { self.first.name = $0; self.update() },
			onEndEditing: Text { [weak self] _ in self?.typeVenue() }
		)
		
		let otherNames = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(first.otherNames.isEmpty),
			text: first.otherNames,
			title: l10n(.otherNames),
			mode: .full(icon: "help_in_form"),
			onEditText: Text { self.first.otherNames = $0; self.update() },
			onEndEditing: Text { [weak self] _ in self?.typeVenue() }
		)
		
		let address = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(first.address.isEmpty),
			text: first.address,
			title: l10n(.objAddress),
			mode: .full(icon: "help_in_form"),
			onEditText: Text { self.first.address = $0; self.update() }
		)
		
		let points = first.point.enumerated().reduce("") { (partialResult, args) -> String in
			let (index, element) = args
			let returned = partialResult + String(element)
			let isLastIndex = index == first.point.count - 1
			return evaluate(isLastIndex, ifTrue: returned, ifFalse: returned + ", ")
		}
		
		let objOnmap = TextFormCell.Props(
			shouldEdit: false,
			canShowRedAlert: shouldBeRed(first.point.isEmpty),
			text: points,
			title: l10n(.objOnMap),
			overlay: "map_1",
			mode: .withoutButton,
			onOverlayTouch: Command {
				let mapPicker = LocationPickerController()
				mapPicker.onDismiss = CommandWith<DKLocation> { location in
					self.first.point = location.numeric
					self.first.address = location.text
					self.update()
					self.reloadAndScroll([2,3], 0)
				}
				let nav = UINavigationController(rootViewController: mapPicker)
				self.present(nav, animated: true, completion: nil)
			}
		)
		
		let category = TextFormCell.Props(
			shouldEdit: false,
			text: currentCategory?.title ?? "",
			title: l10n(.objCategory),
			overlay: "chevron_down",
			mode: .full(icon: "help_in_form"),
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentCategory = $0
						self.currentSub = nil
						self.update()
						self.reloadAndScroll([4,5],0)
					},
					currentValue: self.currentCategory,
					choices: self.categories
				)
			}
		)
		
		let subCategory = TextFormCell.Props(
			shouldEdit: false,
			text: currentSub?.title ?? "",
			title: l10n(.objSubCategory),
			overlay: "chevron_down",
			mode: .full(icon: "help_in_form"),
			onOverlayTouch: Command {
				self.pick(
					with: OnPick {
						self.currentSub = $0
						self.update()
						self.reloadAndScroll([5],0)
					},
					currentValue: self.currentSub,
					choices: self.currentCategory?.subCategories ?? []
				)
			}
		)
		
		let descriptionProps = TextViewCell.Props(
			canShowRedAlert: shouldBeRed(first.description.isEmpty),
			title: l10n(.description),
			placeHolder: "",
			text: first.description,
			onEditText: Text {
				self.first.description = $0
				self.update()
			}
		)
		
		var configurators: [CellConfiguratorType] = [
			CellConfigurator<TextFormCell>(props: objectName),
			CellConfigurator<TextFormCell>(props: otherNames),
			CellConfigurator<TextFormCell>(props: address),
			CellConfigurator<TextFormCell>(props: objOnmap),
			CellConfigurator<TextFormCell>(props: category),
			CellConfigurator<TextFormCell>(props: subCategory),
			CellConfigurator<TextViewCell>(props: descriptionProps)
		]
		configurators.append(contentsOf: videoLinks)
		
		let photoProps = PhotoPickerCell.Props(
			canShowRedAlert: shouldBeRed(images.isEmpty),
			images: images,
			onPick: Command {
				let picker = UIImagePickerController()
				picker.delegate = self
				self.present(picker, animated: true)
			}
		)
		
		configurators.append(CellConfigurator<PhotoPickerCell>(props: photoProps))
		genInfoSectionSource.configurators = configurators
		
		updateValidatables(with: configurators)
	}
	
	var videoLinks: [CellConfigurator<TextFormCell>] {
		
		var links: [TextFormCell.Props] = first.videos.enumerated().map { (index, link) in
			return TextFormCell.Props(
				text: link,
				title: l10n(.videoLink),
				mode: .full(icon: "x_in_form"),
				onRightTouch: Text { _ in
					self.first.videos.remove(atValid: index)
					self.update()
					self.reloadAndScroll(nil, 0)
				},
				onEditText: Text {
					self.first.videos.update(with: $0, at: index)
					self.update()
				}
			)
		}
		
		let emptyLinkCell = TextFormCell.Props(
			text: "",
			title: l10n(.videoLink),
			mode: .full(icon: "plus_in_form"),
			onRightTouch: Text { newText in
				guard !newText.isEmpty else { return }
				self.first.videos.append(newText)
				self.update()
				self.reloadAndScroll(nil, 0)
			},
			onEditText: Text { print($0) }
		)
		
		links.append(emptyLinkCell)
		
		let cells = links.map { CellConfigurator<TextFormCell>(props: $0)}
		return cells
	}
	
	//MARK: - Section Data Sources
	private var dataSource: SectionedTableViewDataSource!
	
	private var genInfoSectionSource: FormTableViewDataSource!

}


extension SmallFormViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = dataSource.titles[section].uppercased()
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell") as? HeaderCell
		header?.props = HeaderCell.Props(title: title, fontSize: 13, section: section, onTap: CommandWith<Int> { section in
			self.dataSource.openBook[section]?.toggle()
			self.reloadAndScroll(nil, section)
		})
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
}

extension SmallFormViewController {
	
	func cellConfigurators(from formGroups: [Group], title: String, section: Int) -> [CellConfiguratorType] {
		
		if !allSections.keys.contains(title) {
			allSections[title] = [String:FormValue]()
		}
	
		var cellsProps = [Any]()
		//begin loop
		formGroups.forEach { group in
			
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
					let atrName = "attribute\(attribute.key)"
					
					if self.allSections[title]?[atrName] == nil {
					 self.allSections[title]?[atrName] = FormValue.not_provided
					}
					
					let cellProps = TextFormCell.Props(
						shouldEdit: false,
						text: allSections[title]?[atrName]?.description ?? "",
						title: attribute.finalTitle,
						overlay: "chevron_down",
						mode: .onlyTextField,
						onOverlayTouch: Command {
							self.pick(
								with: OnPick {
									self.allSections[title]?[atrName] = $0
									self.update(with: self.formAttrs)
									self.reloadAndScroll(nil, section)
								},
								currentValue: FormValue.yes,
								choices: FormValue.allCases
							)
						}
					)
					cellsProps.append(cellProps)
				}
			}
		}
		//end loop
		
		let text = l10n(.zoneScoreInfoText)
		var attributedString: NSAttributedString? {
			let strings = text.components(separatedBy: ".")
			guard strings.count >= 2 else {
				return nil
			}
			let color = UIColor(named: "SelectedTabbarTintColor")
			let atrs: [NSAttributedString.Key : Any] = [
				NSAttributedString.Key.underlineStyle: 1,
				NSAttributedString.Key.underlineColor: color ?? UIColor.blue,
				NSAttributedString.Key.foregroundColor: color ?? UIColor.blue
			]
			let mstr = NSMutableAttributedString(string: strings[0], attributes: atrs)
			mstr.append(NSAttributedString(string: strings[1]))
			return mstr
		}
		
		let commentProps = TextViewCell.Props(
			title: l10n(.zoneScoreInfoText),
			atrTitle: attributedString,
			placeHolder: l10n(.commentaryText),
			text: "",
			onEditText: Text { _ in
				self.update()
			},
			onTitleTap: Command { [weak self] in
				guard let self = self else { return }
				let parameters = ZoneParameters(
					type: "parking_small",
					attributes: self.allSections[title] ?? ["": FormValue.not_provided]
				)
				self.showZoneScore(with: parameters)
			}
		)
		
		cellsProps.append(commentProps)
		
		let configurators: [CellConfiguratorType] = cellsProps.map {
			if let textCellProps = $0 as? TextFormCell.Props {
				return CellConfigurator<TextFormCell>(props: textCellProps)
			} else if let headerProps = $0 as? Header{
				return CellConfigurator<SubSectionHeaderCell>(props: headerProps)
			} else {
				return CellConfigurator<TextViewCell>(props: $0 as! TextViewCell.Props)
			}
		}
		
		return configurators
	}
}


extension SmallFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		images.insert(image, at: 0)
		update()
		reloadAndScroll(nil, 0)
		onPickImage.perform(with: image)
		dismiss(animated: true)
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
