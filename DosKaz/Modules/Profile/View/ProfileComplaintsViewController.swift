//
//  ProfileComplaintsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileComplaintsViewController: ProfileCommonViewController {
	
	var dataSource: UTableViewDataSource<ComplaintCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.myComplaints), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		dataSource.cellsProps = [
			ComplaintCell.Props(
				title: "Суши-бар Saya Sushi",
				text: "Жалоба на отсутствие доступа на объект или несоответствие функциональных зон объекта требованиям нормативного законодательства",
				subTitle: "Вчера в 18:01 объекту объекту клик клик"
			)
		]
		tableView.dataSource = dataSource
		tableView.reloadData()
	}
	
}

class ComplaintCell: UITableViewCell, Updatable {
	
	let titleLabel = UILabel()
	let button = Button(type: .system)
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.textColor = .gray
		detailTextLabel?.numberOfLines = 0
		titleLabel.decorate(with: Style.systemFont(size: 14, weight: .semibold), { label in
			label.numberOfLines = 0
		})
		
		button.setTitle(l10n(.downLoadComplaints), for: .normal)
		button.setImage(UIImage(named: "plus_in_form"), for: .normal)
		button.titleLabel?.font = detailTextLabel?.font
		button.setTitleColor(detailTextLabel?.textColor, for: .normal)
		
		layoutCustomSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func layoutCustomSubviews() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(button)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
		
		textLabel?.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 4)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
		
		detailTextLabel?.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: textLabel!, plus: 8)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.bottom)
		
		button.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: textLabel!, plus: 8)
			.pin(my: .leading, to: .trailing, of: detailTextLabel!)
			.pinEdgeToSupers(.trailing)
			
		
		detailTextLabel?.setContentHuggingPriority(.defaultLow, for: .horizontal)
		detailTextLabel?.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
	}
	
	var props: Props! {
		didSet {
			titleLabel.text = props.title
			textLabel?.text = props.text
			detailTextLabel?.text = props.subTitle
		}
	}
	
	struct Props {
		let title: String
		let text: String?
		var subTitle: String?
	}
	
}
