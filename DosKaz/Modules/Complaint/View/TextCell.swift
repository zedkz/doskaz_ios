//
//  TextCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/23/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell, Updatable {
	
	let label = UILabel()
	let blueLine = UIView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		label.numberOfLines = 0
		
		contentView.addSubview(label)
		contentView.addSubview(blueLine)
		
		blueLine.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.set(my: .height, to: 8)
		
		label.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: blueLine, plus: 8)
			.pinEdgeToSupers(.leading, plus: 24)
			.pinEdgeToSupers(.trailing, plus: -24)
			.pinEdgeToSupers(.bottom, plus: -8)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	var props: Props! {
		didSet {
			label.attributedText = props.title
			let blue = UIColor(named:"FilterHeaderColor")
			blueLine.backgroundColor = evaluate(props.isBlue, ifTrue: blue, ifFalse: .white)
		}
	}
	
	struct Props {
		let title: NSAttributedString
		let isBlue: Bool
	}
	
}


