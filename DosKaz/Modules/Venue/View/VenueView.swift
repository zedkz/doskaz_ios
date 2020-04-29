//
//  VenueView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/26/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class UIVenueView: UIView {
	
	//MARK: -inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		configureConstantData()
		configureStyle()
		configureBehaviour()
		VenueViewLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	var props: VenueProps! {
		didSet {
			guard let props = props else { return }
			let venue = props.doskazVenue
			func update(_ label: UILabel, with text: String) {
				UIView.transition(
					with: label,
					duration: 0.25,
					options: .transitionCrossDissolve,
					animations: { [label] in label.text = text },
					completion: nil
				)
			}
			update(title, with: venue.title)
			update(subTitle,with: venue.address)
			update(categoryAndSub, with: "\(venue.category) > \(venue.subCategory)")
			
			let firstCellProps = Props(icon: "available_32", text: venue.overallScore, isMain: true)
			let scoreByZones = venue.scoreByZones
			let cellsProps = [
				Props(icon: "available_16", text: scoreByZones.parking),
				Props(icon: "available_16", text: scoreByZones.entrance),
				Props(icon: "available_16", text: scoreByZones.movement),
				Props(icon: "available_16", text: scoreByZones.navigation),
				Props(icon: "available_16", text: scoreByZones.serviceAccessibility),
				Props(icon: "available_16", text: scoreByZones.toilet),
			]
			
			dataSource.cellsProps = [firstCellProps] + cellsProps
			tableView.reloadData()
		}
	}

	
	let panelDragger = UIImageView()
	let title = UILabel()
	let subTitle = UILabel()
	let categoryAndSub = UILabel()
	let editButton = UIButton()
	let tableView = ContentSizedTableView()
	
	//MARK: - Private
	
	var dataSource: TableViewDataSource<Props,AccessibilityCell>!

	private func configureConstantData() {
		panelDragger.image = UIImage(named: "dragger")
		title.text = "Saya sushi, sushi bar"
		subTitle.text = "ul. Lokomotivnaya,7"
		categoryAndSub.text = "Pitanie > Bary"
		editButton.setImage(UIImage(named: "edit_active"), for: .normal)
		editButton.setImage(UIImage(named: "edit"), for: .disabled)
		
		dataSource = TableViewDataSource(tableView) { (props, cell) in
			cell.textLabel?.text = props.text
			cell.imageView?.image = UIImage(named:props.icon)
			cell.isMainCell = props.isMain
			cell.backgroundColor = .brown
			cell.selectionStyle = .none
			cell.isUserInteractionEnabled = false
		}
		
		let firstCellProps = Props(icon: "available_32", text: "Dostupno", isMain: true)
		let cellsProps = [Props(icon: "available_16", text: "Parkovka")]
		dataSource.cellsProps = [firstCellProps] + cellsProps
		
		tableView.dataSource = dataSource
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView()
	}
	
	private func configureStyle() {
		panelDragger.contentMode = .center
		title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
		title.numberOfLines = 0
		subTitle.font = .systemFont(ofSize: 14)
		subTitle.numberOfLines = 0
		categoryAndSub.font = .systemFont(ofSize: 12)
		categoryAndSub.numberOfLines = 0
		categoryAndSub.textColor = .systemGray
		backgroundColor = .white
	}
		
	private func configureBehaviour() {
		tableView.isScrollEnabled = false
	}
	
	// MARK: - Sub types
	
	struct VenueProps {
		var doskazVenue: DoskazVenue
	}
	
	struct Props {
		let icon: String
		let text: String
		var isMain: Bool = false
	}
	
}

struct VenueViewLayout {
	weak var rv: UIVenueView!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension VenueViewLayout {
	
	func addSubviews() {
		rv.addSubview(rv.panelDragger)
		rv.addSubview(rv.title)
		rv.addSubview(rv.subTitle)
		rv.addSubview(rv.categoryAndSub)
		rv.addSubview(rv.editButton)
		rv.addSubview(rv.tableView)
	}
	
	func addConstraints() {
		rv.panelDragger.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.set(my: .height, to: 20)
		
		rv.title.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 16)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: rv.panelDragger)
		
		rv.subTitle.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 16)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: rv.title, plus: 8)
		
		rv.categoryAndSub.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 16)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: rv.subTitle, plus: 8)
		
		rv.editButton.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing, plus: -8)
			.pin(my: .verticalCenter, andOf: rv.categoryAndSub)
			
		rv.tableView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: rv.editButton)
			.pinEdgeToSupers(.bottom)
	}
	
}


class AccessibilityCell: UITableViewCell {
	
	var isMainCell = false
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if !isMainCell {
			self.imageView?.frame.origin.x += 8
			self.textLabel?.frame.origin.x += 16
		}
	}
}
