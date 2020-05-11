//
//  FormCells.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class TextFormCell: UITableViewCell {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		//MARK: - Configure constant data
		textField.placeholder = "Наименование"
		
		//MARK: - Configure style
		textField.borderStyle = .roundedRect
		
		//MARK: - Configure behavior
		//MARK: - Layout
		contentView.addSubview(textField)
		textField.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(all: 8))
			.set(my: .height, to: 50)
	}
	
	//MARK: - Public properties and methods
	let textField = UITextField()
	
	var props: Props! {
		didSet {
			
		}
	}
	
	//MARK: - Sub types
	struct Props {
		var title: String
	}
	
}
