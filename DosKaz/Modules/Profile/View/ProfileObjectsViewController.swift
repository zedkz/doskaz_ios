//
//  ProfileObjectsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/19/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileObjectsViewController: ProfileCommonViewController {
	
	var dataSource: UTableViewDataSource<ObjectCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.myObjects), isRightButtonHidden: false)
		dataSource = UTableViewDataSource(tableView)
		dataSource.cellsProps = [
			ObjectCell.Props(
				title: "Добавьте 15 объектов в городе",
				subTitle: "6 june",
				cornerText: "corener",
				image: UIImage(named: "ins_pic_1")
			)
		]
		tableView.dataSource = dataSource
		tableView.reloadData()
		tableView.allowsSelection = false
	}
	
}

class ObjectCell: UITableViewCell, Updatable {
	
	let cornerLabel = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.textColor = .gray
		
		cornerLabel.textAlignment = .right
		cornerLabel.textColor = .gray
		cornerLabel.font = detailTextLabel?.font
		contentView.addSubview(cornerLabel)
		
		imageView?.backgroundColor = .red
		detailTextLabel?.backgroundColor = .blue
		textLabel?.backgroundColor = .yellow
		
		imageView?.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.set(my: .height, to: 60)
			.set(my: .width, to: 60)
		
		textLabel?.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pin(my: .leading, to: .trailing, of: imageView!, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -8)
		
		detailTextLabel?.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: imageView!, plus: 10)
			.set(my: .top, .greaterThanOrEqual, to: .bottom, of: textLabel!, plus: 4)
			.set(my: .bottom, .lessThanOrEqual, to: .bottom, of: contentView, plus: -4)

		let constraint = detailTextLabel?.bottomAnchor.constraint(equalTo: imageView!.bottomAnchor)
		constraint?.priority = .defaultLow
		constraint?.isActive = true
		
		cornerLabel.addConstraintsProgrammatically
			.pin(my: .top, andOf: detailTextLabel!)
			.pin(my: .bottom, andOf: detailTextLabel!)
			.pin(my: .leading, to: .trailing, of: detailTextLabel!)
			.pin(my: .trailing, andOf: textLabel!)

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			detailTextLabel?.text = props.subTitle
			imageView?.image = props.image
			cornerLabel.text = props.cornerText
			
		}
	}
	
	struct Props {
		let title: String
		var subTitle: String?
		var cornerText: String?
		var image: UIImage?
	}
	
}
