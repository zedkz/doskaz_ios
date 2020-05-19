//
//  ProfileTasksViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/19/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileTasksViewController: ProfileCommonViewController {
	
	var dataSource: UTableViewDataSource<TaskCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.myTasks), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		dataSource.cellsProps = [TaskCell.Props(title: "Добавьте 15 объектов в городе", subTitle: "6 june", image: UIImage(named: "aged_people"))]
		tableView.dataSource = dataSource
		tableView.reloadData()
	}

}

class TaskCell: UITableViewCell, Updatable {
	
	let cornerLabel = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.textColor = .gray
		
		cornerLabel.textAlignment = .right
		cornerLabel.textColor = .gray
		
		contentView.addSubview(cornerLabel)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.imageView?.frame.origin.x -= 20
		self.detailTextLabel?.frame.origin.x -= 20
		self.textLabel?.frame.origin.x -= 20
		guard let dtx = detailTextLabel else { return }
		let frame = CGRect(
			x: dtx.frame.maxX,
			y: dtx.frame.origin.y,
			width: contentView.frame.width - dtx.frame.maxX,
			height: dtx.frame.height
		)
		cornerLabel.frame = frame
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			detailTextLabel?.text = props.subTitle
			imageView?.image = props.image
		}
	}
	
	struct Props {
		let title: String
		var subTitle: String?
		var image: UIImage?
	}
	
}
