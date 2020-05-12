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
	
	@objc func handleRightButtonTouch() {
		textField.text = nil
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		
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
		rightButton.setImage(UIImage(named: "clear_search"), for: .normal)
		validationLabel.text = l10n(.fillTheField)
		validationLabel.numberOfLines = 0
		
		//MARK: - Configure style
		textField.borderStyle = .none
		textField.layer.borderColor = UIColor(named: "TextFieldBorderColor")?.cgColor
		textField.layer.borderWidth = 1
		textField.layer.cornerRadius = 3
		textField.font = .systemFont(ofSize: 14)
		titleLabel.decorate(with: Style.systemFont(size: 14))
		
		validationLabel.decorate(with: Style.systemFont(size: 12), { (label) in
			label.textColor = .red
		})
		
		//MARK: - Configure behavior
		rightButton.addTarget(self, action: #selector(handleRightButtonTouch), for: .touchUpInside)
		
		//MARK: - Layout
		contentView.addSubview(titleLabel)
		contentView.addSubview(textField)
		contentView.addSubview(rightButton)
		contentView.addSubview(validationLabel)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 12)
			.pinEdgeToSupers(.leading,plus: 22)
			.pinEdgeToSupers(.trailing, plus: -24)
			.pin(my: .bottom, to: .top, of: textField, plus: -8)
		textField.addConstraintsProgrammatically
			.pin(my: .leading, andOf: titleLabel)
			.set(my: .height, to: 40)

		textToButton = textField.addConstraintsProgrammatically
			.pin(my: .trailing, to: .leading, of: rightButton)
			.constraint
		textToButton.isActive = false

		textToSuper = textField.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing, plus: -22)
			.constraint
		textToSuper.isActive = false
		
		let buttonWidth = rightButton.widthAnchor.constraint(equalToConstant: 44)
		buttonWidth.priority = .defaultLow
		buttonWidth.isActive = true

		rightButton.addConstraintsProgrammatically
			.pin(my: .top, andOf: textField)
			.pin(my: .bottom, andOf: textField)
			.pinEdgeToSupers(.trailing)
			
		validationLabel.addConstraintsProgrammatically
			.pin(my: .leading, andOf: titleLabel)
			.pin(my: .top, to: .bottom, of: textField,plus: 2)
			.pinEdgeToSupers(.bottom, plus: -12)
			.pinEdgeToSupers(.trailing, plus: -22)
		
		set(mode: .onlyTextField)
	}
	
	//MARK: - Public properties and methods
	let textField = UITextField()
	let titleLabel = UILabel()
	let rightButton = Button()
	let validationLabel = UILabel()
	
	var props: Props! {
		didSet {
			set(mode: props.mode)
		}
	}
	
	//MARK: - Sub types
	struct Props {
		var title: String
		var mode: TextfieldMode = .onlyTextField
	}
	
	//MARK: - Private
	var textToButton: NSLayoutConstraint!
	var textToSuper: NSLayoutConstraint!
	
	private func set(mode: TextfieldMode) {
		switch mode {
		case .full:
			textToButton.isActive = true
			textToSuper.isActive = false
			rightButton.isHidden = false
		case .withoutButton:
			textToButton.isActive = true
			textToSuper.isActive = false
			rightButton.isHidden = true
		case .onlyTextField:
			textToButton.isActive = false
			textToSuper.isActive = true
			rightButton.isHidden = true
		}
		
		contentView.setNeedsLayout()
	}
	
}

enum TextfieldMode {
	case full
	case withoutButton
	case onlyTextField
}
