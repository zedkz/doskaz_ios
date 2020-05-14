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
		picture.backgroundColor = .systemGray
		//MARK: - Configure behavior
		//MARK: - Layout
		contentView.addSubview(container)
		
		container.addConstraintsProgrammatically
			.pinToSuper()
		
		container.addArrangedSubview(titleLabel)
		container.addArrangedSubview(picture)
		
		picture.addConstraintsProgrammatically
			.set(my: .height, to: 184)
			
	}
	
	//MARK: - Public properties and methods
	var props: Props! {
		didSet {
			titleLabel.text = props.title
		}
	}
	let container: UIStackView = {
		let s = UIStackView()
		s.axis = .vertical
		s.isLayoutMarginsRelativeArrangement = true
		s.layoutMargins = UIEdgeInsets(all: 24)
		return s
	}()
	let titleLabel = UILabel()
	let picture = UIImageView()
	
	//MARK: - Sub types
	struct Props {
		var title: String
		var imageURL: String
	}
	
}
