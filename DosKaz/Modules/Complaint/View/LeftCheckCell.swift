//
//  LeftCheckCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/22/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class LeftCheckCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapGestureRecognizer)
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
			let imageName = props.isChecked ? "check_activated" : "check_not_activated"
			imageView?.image = UIImage(named: imageName)
		}
	}
	
	struct Props {
		let title: String
		var isChecked: Bool
		var onTap: Command
	}
	
}

