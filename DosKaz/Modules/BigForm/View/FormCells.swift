//
//  FormCells.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class TextFormCell: UITableViewCell, Updatable {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	@objc func handleTexfieldOverlay() {
		print("dfnsjdnfsdfsdnfdsk")
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//MARK: - Configure text field overlay
		
		if let overlayImage = UIImage(named: "available_16") {
			let overlayButton = UIButton(type: .custom)
			overlayButton.setImage(UIImage(named: "available_16"), for: .normal)
			overlayButton.addTarget(self, action: #selector(handleTexfieldOverlay), for: .touchUpInside)
			overlayButton.frame = CGRect(x: 0, y: 0, width: overlayImage.size.width + 20, height: overlayImage.size.height)
			
			textField.rightView = overlayButton
			textField.rightViewMode = .always
			
			let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
			textField.leftView = spaceView
			textField.leftViewMode = .always
		}
		
		//MARK: - Configure constant data
		textField.text = "ya know oeopyotototoep peppers and dida"
		textField.placeholder = "Наименование"
		
		//MARK: - Configure style
		textField.borderStyle = .none
		textField.layer.borderColor = UIColor.red.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 3
		
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
