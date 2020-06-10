//
//  DetailViewContoller.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/10/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class DetailViewContoller: TableViewController, UITableViewDelegate {
	
	var venue: DoskazVenue!
	
	var zones: Zones { venue.attributes.zones	}
	
	private var dataSource: SectionedTableViewDataSource!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = l10n(.detailInfo)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "x_in_form"), style: .done,
			target: self,
			action: #selector(close)
		)
		tableView.register(HeaderCell.self, forHeaderFooterViewReuseIdentifier: "HeaderCell")
		tableView.register(cellClass: CommentCell.self)
		tableView.register(cellClass: SubSectionHeaderCell.self)
		
		loadFormAtrs()
	}
	
	private func loadFormAtrs() {
		if let attrs = FormAttributesStorage.shared.retrieveData() {
			buildTable(from: attrs)
			return
		}
		
		let onSuccess = { [weak self] (formAttributes: FormAttributes) -> Void in
			self?.buildTable(from: formAttributes)
			FormAttributesStorage.shared.store(formAttributes)
		}
		
		let onFailure = { (error: Error) -> Void in
			print(error)
		}
		
		APIFormAttributes(onSuccess: onSuccess, onFailure: onFailure).dispatch()
		
	}
	
	private func buildTable(from formAttrs: FormAttributes) {

		var formType: Full {
			switch venue.attributes.form {
			case "small": return formAttrs.small
			case "middle": return formAttrs.middle
			case "full": return formAttrs.full
			default: return formAttrs.full
			}
		}
		
		dataSource = SectionedTableViewDataSource(dataSources: [
			FormTableViewDataSource(l10n(.parking), items(formType.parking, l10n(.parking), zones.parking)),
			FormTableViewDataSource(l10n(.entrance), items(formType.entrance, l10n(.entrance), zones.entrance1)),
			FormTableViewDataSource(l10n(.movement), items(formType.movement, l10n(.movement), zones.movement)),
			FormTableViewDataSource(l10n(.service), items(formType.service, l10n(.service), zones.service)),
			FormTableViewDataSource(l10n(.toilet), items(formType.toilet, l10n(.toilet), zones.toilet)),
			FormTableViewDataSource(l10n(.navigation), items(formType.navigation, l10n(.navigation), zones.navigation)),
			FormTableViewDataSource(l10n(.serviceAccessibility), items(formType.serviceAccessibility, l10n(.serviceAccessibility), zones.serviceAccessibility))
		])
		
		tableView.dataSource = dataSource
		tableView.delegate = self
		tableView.reloadData()
	}
	
	func items(_ formGroups: [Group], _ title: String, _ values: [String: FormValue]) -> [CellConfiguratorType] {

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
										
					let cellProps = CommentCell.Props(
						title: attribute.finalTitle,
						subTitle: values[atrName]?.description
					)
					
					cellsProps.append(cellProps)
				}
			}
		}
		//end loop
		
		let configurators: [CellConfiguratorType] = cellsProps.map {
			if let textCellProps = $0 as? CommentCell.Props {
				return CellConfigurator<CommentCell>(props: textCellProps)
			} else {
				return CellConfigurator<SubSectionHeaderCell>(props: $0 as! Header)
			}
		}
		
		return configurators
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = dataSource.titles[section].uppercased()
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell") as? HeaderCell
		header?.props = HeaderCell.Props(title: title, fontSize: 13, section: section)
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
}
