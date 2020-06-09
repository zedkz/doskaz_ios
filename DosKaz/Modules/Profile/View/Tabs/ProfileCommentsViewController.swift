//
//  ProfileCommentsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileCommentsViewController: ProfileCommonViewController {
	
	var dataSource: UTableViewDataSource<CommentCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.myComments), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		dataSource.cellsProps = [
			CommentCell.Props(
				title: "Хотелось бы добавить, что входная группа сделана не очень удобно для людей, передвигающихся на колясках. Угол наклона пандуса очень большой, подниматься без посторонней помощи сложно. А зимой там ещё хуже будет.",
				subTitle: "Вчера в 18:01 к объекту Стоматологическая клиника Vitadent"
			)
		]
		tableView.dataSource = dataSource
		tableView.reloadData()
	}
	
}

class CommentCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.textColor = .gray
		detailTextLabel?.numberOfLines = 0
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		detailTextLabel?.frame.origin.x = 0
		textLabel?.frame.origin.x = 0
		textLabel?.frame.size.width = contentView.frame.width
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			detailTextLabel?.text = props.subTitle
		}
	}
	
	struct Props {
		let title: String
		var subTitle: String?
	}
	
}
