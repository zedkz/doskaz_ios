//
//  DetailViewCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/10/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import Foundation

class DetailViewCell: UITableViewCell, Updatable {
	
	let titleL = UILabel()
	let subTitleL = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		titleL.decorate(with: Style.systemFont(size: 14), { label in
			label.numberOfLines = 0
		})
		subTitleL.decorate(with: Style.systemFont(size: 14))
		
		contentView.addSubview(titleL)
		contentView.addSubview(subTitleL)

		titleL.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 12)
			.pinEdgeToSupers(.leading, plus: 24)
			.pinEdgeToSupers(.trailing, plus: -16)
		
		subTitleL.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleL, plus: 16)
			.pinEdgeToSupers(.leading, plus: 24)
			.pinEdgeToSupers(.trailing, plus: -16)
			.pinEdgeToSupers(.bottom, plus: -12)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var props: Props! {
		didSet {
			titleL.text = props.title
			subTitleL.attributedText = props.subTitle
		}
	}
	
	struct Props {
		let title: String
		var subTitle: NSAttributedString?
	}
	
}
