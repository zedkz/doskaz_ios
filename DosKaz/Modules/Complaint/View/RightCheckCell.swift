//
//  RightCheckCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/22/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class RightCheckCell: UITableViewCell, Updatable {
	

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapGestureRecognizer)
		let image = UIImage(named: "check_in_form")
		accessoryView = UIImageView(image: image)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func handleTap() {
		props.onTap.perform()
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			accessoryView?.isHidden = !props.isChecked
		}
	}
	
	struct Props {
		let title: String
		var isChecked: Bool
		var onTap: Command
	}
	
}

