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
			
			var backGroundColor: UIColor? {
				switch venue.overallScore {
				case .fullAccessible: return UIColor(named: "AccessFull")
				case .partialAccessible: return UIColor(named: "AccessPartial")
				case .notAccessible: return UIColor(named: "AccessNone")
				case .notProvided: return .white
				}
			}
			
			tableView.backgroundColor = backGroundColor
			
			let firstCellProps = Props(score: venue.overallScore, text: "Overall Score", isMain: true)
			let scoreByZones = venue.scoreByZones
			let cellsProps = [
				Props(score: scoreByZones.parking, text: l10n(.parking)),
				Props(score: scoreByZones.entrance, text: l10n(.entrance)),
				Props(score: scoreByZones.movement, text: l10n(.movement)),
				Props(score: scoreByZones.navigation, text: l10n(.navigation)),
				Props(score: scoreByZones.serviceAccessibility, text: l10n(.serviceAccessibility)),
				Props(score: scoreByZones.toilet, text: l10n(.toilet)),
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
			cell.textLabel?.text = props.textDisplayed
			cell.imageView?.image = UIImage(named:props.icon)
			cell.isMainCell = props.isMain
			cell.backgroundColor = .clear
			cell.selectionStyle = .none
			cell.isUserInteractionEnabled = false
		}
		
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
		let score: OverallScore
		let text: String
		var isMain: Bool = false

		var icon: String {
			switch score {
			case .fullAccessible:
				return evaluate(isMain, ifTrue: "available_32", ifFalse: "available_16")
			case .partialAccessible:
				return evaluate(isMain, ifTrue: "partially_available_32", ifFalse: "partially_available_16")
			case .notAccessible:
				return evaluate(isMain, ifTrue: "not_available_32", ifFalse: "not_available_16")
			case .notProvided:
				return evaluate(isMain, ifTrue: "partially_available_16", ifFalse: "partially_available_16")
			}
		}
		
		var textDisplayed: String {
			guard isMain else { return text }
			switch score {
			case .fullAccessible: return l10n(.accessibleFull)
			case .partialAccessible: return l10n(.accessiblePartial)
			case .notAccessible: return l10n(.accessibleNone)
			case .notProvided: return l10n(.accessbleNotProvided)
			}
		}
		
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
			.pinEdgeToSupers(.trailing, plus: -4)
			.pin(my: .top, to: .bottom, of: rv.panelDragger)
		
		rv.subTitle.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 16)
			.pinEdgeToSupers(.trailing, plus: -4)
			.pin(my: .top, to: .bottom, of: rv.title, plus: 8)
		
		rv.categoryAndSub.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 16)
			.pin(my: .trailing, to: .leading, of: rv.editButton, plus: -4)
			.pin(my: .top, to: .bottom, of: rv.subTitle, plus: 8)
		
		rv.editButton.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing, plus: -8)
			.pin(my: .verticalCenter, andOf: rv.categoryAndSub)
			
		rv.tableView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: rv.editButton, plus: 8)
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
