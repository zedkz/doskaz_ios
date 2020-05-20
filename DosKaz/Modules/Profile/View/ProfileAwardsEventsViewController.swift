//
//  ProfileAwardsEventsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileAwardsEventsViewController: ProfileCommonViewController {
	
	var dataSource: UTableViewDataSource<EventCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.eventsFeed), isRightButtonHidden: true)
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
