//
//  ProfileAwardsEventsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileAwardsEventsViewController: UIViewController {
	
	let awardsLabel = UILabel()
	let eventsLabel = UILabel()
	let tableView = ContentSizedTableView()
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
	
	var dataSource: UTableViewDataSource<EventCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		awardsLabel.text = l10n(.awards)
		eventsLabel.text = l10n(.eventsFeed)
		updateTableData()
		layout()
	}
	
	private func layout() {
		collectionView.backgroundColor = .cyan
		tableView.backgroundColor = .darkText
		awardsLabel.decorate(with: Style.systemFont(size: 18, weight: .semibold))
		eventsLabel.decorate(with: Style.systemFont(size: 18, weight: .semibold))
		tableView.separatorInset = UIEdgeInsets(all: 0)
		tableView.separatorStyle = .none
		
		view.addSubview(awardsLabel)
		view.addSubview(eventsLabel)
		let line = UIView()
		line.backgroundColor = UIColor(named: "UnselectedTabbarTintColor")?.withAlphaComponent(0.2)
		view.addSubview(line)
		view.addSubview(tableView)
		view.addSubview(collectionView)
		
		let spacing: CGFloat = 16

		awardsLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
		
		collectionView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: awardsLabel, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
			.set(my: .height, to: 200)
		
		line.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: collectionView, plus: spacing)
			.pinEdgeToSupers(.leading, plus: 0)
			.pinEdgeToSupers(.trailing, plus: -0)
			.set(my: .height, to: 1)

		eventsLabel.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: line, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
		
		tableView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: eventsLabel, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
			.pinEdgeToSupers(.bottom, plus: -spacing)
	
	}
	
	fileprivate func updateTableData() {
		dataSource = UTableViewDataSource(tableView)
		dataSource.cellsProps = [
			EventCell.Props(
				date: "12 августа",
				text: "Арай Молдахметова прокомментировала ваш объект Суши-бар Saya Sushi"
			)
		]
		tableView.dataSource = dataSource
		tableView.reloadData()
	}
	
}

class EventCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.numberOfLines = 0
		
		let tempFont = detailTextLabel?.font
		detailTextLabel?.font = textLabel?.font
		textLabel?.font = tempFont
		
		detailTextLabel?.textColor = textLabel?.textColor
		textLabel?.textColor = .gray
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.detailTextLabel?.frame.origin.x -= 20
		self.textLabel?.frame.origin.x -= 20
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.date
			detailTextLabel?.text = props.text
		}
	}
	
	struct Props {
		let date: String?
		var text: String?
	}
	
}
