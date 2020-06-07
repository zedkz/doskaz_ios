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

import SharedCodeFramework

class HeaderCell: UITableViewHeaderFooterView {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		//MARK: - Configure constant data
		//MARK: - Configure style
		
	
		//UIColor(named: "UnselectedTabbarTintColor")?.withAlphaComponent(0.7)
		titleLabel.decorate(with: { label in
			label.numberOfLines = 0
			label.textColor = UIColor(named: "FilterHeaderTextColor")
		})
		
		//MARK: - Configure behavior
//		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//		addGestureRecognizer(tap)
		
		//MARK: - Layout
		contentView.backgroundColor = UIColor(named:"FilterHeaderColor")
		contentView.addSubview(titleLabel)
		
		contentView.addSubview(countLabel)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.leading, plus: 22)

		countLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.trailing, plus: -22)
			.pin(my: .leading, to: .trailing, of: titleLabel, plus: 8)
		
		countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		arrowImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
	}
	
	@objc func handleTap() {
		
	}
	
	//MARK: - Public properties and methods
	var props: Props! {
		didSet {
			titleLabel.text = props.title
			titleLabel.decorate(with: Style.systemFont(size: props.fontSize))
			let imageName = props.isOpen ? "chevron_up" : "chevron_down"
			arrowImage.image = UIImage(named: imageName)
			if let count = props.count {
				countLabel.text = String(count)
			} else {
				countLabel.text = nil
			}
		}
	}
	
	let titleLabel = UILabel()
	let countLabel = UILabel()
	let arrowImage = UIImageView()
	
	//MARK: - Sub types
	
	struct Props {
		var isOpen: Bool = true
		var count: Int? = nil
		let title: String
		var fontSize: CGFloat = 14
		var section: Int
		var onTap: CommandWith<Int> = .nop
	}
	
}
