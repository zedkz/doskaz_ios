//
//  SubSectionHeaderCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class SubSectionHeaderCell: UITableViewCell, Updatable {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		//MARK: - Configure constant data
		//MARK: - Configure style
		backgroundColor = UIColor(named: "UnselectedTabbarTintColor")?.withAlphaComponent(0.7)
		titleLabel.decorate(with: { label in
			label.numberOfLines = 0
		})

		//MARK: - Configure behavior
		//MARK: - Layout
		contentView.addSubview(titleLabel)
		titleLabel.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 8, left: 22, bottom: 8, right: 8))
	}
	
	//MARK: - Public properties and methods
	var props: Props! {
		didSet {
			titleLabel.text = props.title
			titleLabel.decorate(with: Style.systemFont(size: props.fontSize))
		}
	}
	
	let titleLabel = UILabel()
	
	//MARK: - Sub types
	
	struct Props {
		let title: String
		var fontSize: CGFloat = 14
	}
	
}

typealias Header = SubSectionHeaderCell.Props
