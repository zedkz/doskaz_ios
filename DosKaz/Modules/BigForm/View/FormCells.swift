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
		textField.text = "Астана"
		textField.placeholder = "Наименование"
		titleLabel.text = "Наличие оборудованных парковочных мест (Не менее 1 места на парковке)"
		titleLabel.numberOfLines = 0
		
		//MARK: - Configure style
		textField.borderStyle = .none
		textField.layer.borderColor = UIColor(named: "TextFieldBorderColor")?.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 3
		textField.font = .systemFont(ofSize: 14)
		titleLabel.decorate(with: Style.systemFont(size: 14))
		
		//MARK: - Configure behavior
		//MARK: - Layout
		contentView.addSubview(titleLabel)
		contentView.addSubview(textField)
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 8)
			.pinEdgeToSupers(.leading,plus: 24)
			.pinEdgeToSupers(.trailing, plus: -24)
			.pin(my: .bottom, to: .top, of: textField, plus: -8)
		textField.addConstraintsProgrammatically
			.pin(my: .leading, andOf: titleLabel)
			.pinEdgeToSupers(.trailing, plus: -24)
			.pinEdgeToSupers(.bottom, plus: -8)
			.set(my: .height, to: 40)
	}
	
	//MARK: - Public properties and methods
	let textField = UITextField()
	let titleLabel = UILabel()
	
	var props: Props! {
		didSet {
			
		}
	}
	
	//MARK: - Sub types
	struct Props {
		var title: String
	}
	
}
