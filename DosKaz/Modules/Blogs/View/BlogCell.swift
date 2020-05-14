//
//  BlogCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class BlogCell: UITableViewCell, Updatable {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//MARK: - Configure constant data
		titleLabel.numberOfLines = 0
		
		//MARK: - Configure style
		//MARK: - Configure behavior
		//MARK: - Layout
		contentView.addSubview(titleLabel)
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
	}
	
	//MARK: - Public properties and methods
	var props: Props! {
		didSet {
			titleLabel.text = props.title
		}
	}
	let titleLabel = UILabel()
	
	//MARK: - Sub types
	struct Props {
		var title: String
	}
	
}
