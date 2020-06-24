//
//  FormCells.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

typealias Text = CommandWith<String>

import SharedCodeFramework

class TextFormCell: UITableViewCell, Updatable {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	@objc func handleTexfieldOverlay() {
		print("handleTexfieldOverlay")
		props.onOverlayTouch.perform()
	}
	
	@objc func handleRightButtonTouch() {
		props.onRightTouch.perform(with: textField.text ?? "")
	}
	
	@objc func handleTextfiled(_ textField: UITextField) {
		let result = props.formatter(textField.text ?? "")
		textField.text = result
		props.onEditText.perform(with: result)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		
		//MARK: - Configure text field right view

		rightViewWidth = overlayButton.addConstraintsProgrammatically
			.set(my: .height, to: 40)
			.set(my: .width, to: 16 + 20)
			.constraint
		
		textField.rightView = overlayButton
		textField.rightViewMode = .always
		
		//MARK: - Configure text field left padding
		
		let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
		textField.leftView = spaceView
		textField.leftViewMode = .always
		
		//MARK: - Configure constant data
		textField.placeholder = "-"
		titleLabel.text = "-"
		titleLabel.numberOfLines = 0
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
		overlayButton.addTarget(self, action: #selector(handleTexfieldOverlay), for: .touchUpInside)
		rightButton.addTarget(self, action: #selector(handleRightButtonTouch), for: .touchUpInside)
		textField.delegate = self
		textField.addTarget(self, action: #selector(handleTextfiled(_:)), for: .editingChanged)
		
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
			.pin(my: .trailing, to: .leading, of: rightButton)
		
		buttonWidth = rightButton.addConstraintsProgrammatically
			.pin(my: .top, andOf: textField)
			.pin(my: .bottom, andOf: textField)
			.pinEdgeToSupers(.trailing)
			.set(my: .width, to: 44)
			.constraint
			
		validationLabel.addConstraintsProgrammatically
			.pin(my: .leading, andOf: titleLabel)
			.pin(my: .top, to: .bottom, of: textField,plus: 2)
			.pinEdgeToSupers(.bottom, plus: -8)
			.pinEdgeToSupers(.trailing, plus: -22)
		
		set(mode: .onlyTextField)
	}
	
	//MARK: - Public properties and methods
	let textField = UITextField()
	let titleLabel = UILabel()
	let rightButton = Button()
	let validationLabel = UILabel()
	let overlayButton = UIButton(type: .custom)
	var rightViewWidth: NSLayoutConstraint!
	
	var props: Props! {
		didSet {
			textField.text = props.text
			set(mode: props.mode)
			handle(isShowRedAlert: props.canShowRedAlert)
			titleLabel.text = props.title
			if let imageName = props.overlay ,let overlayImage = UIImage(named: imageName) {
				overlayButton.setImage(overlayImage, for: .normal)
				rightViewWidth.constant = 36
			} else {
				overlayButton.setImage(nil, for: .normal)
				rightViewWidth.constant = 0
			}
			
		}
	}
	
	//MARK: - Sub types
	struct Props {
		var shouldEdit: Bool = true
		var canShowRedAlert: Bool = false
		var text: String
		var title: String
		var overlay: String?
		var rightImage: String?
		var mode: TextfieldMode = .onlyTextField
		var onRightTouch: Text = .nop
		var onOverlayTouch: Command = .nop
		var onEditText: Text = .nop
		var formatter: (String) -> String = { input in return input }
		var onEndEditing: Text = .nop
	}
	
	//MARK: - Private
	var buttonWidth: NSLayoutConstraint!
	
	private func set(mode: TextfieldMode) {
		switch mode {
		case .full(let imageName):
			rightButton.setImage(UIImage(named: imageName), for: .normal)
			
			buttonWidth.constant = 44.0
			rightButton.isHidden = false
		case .withoutButton:
			buttonWidth.constant = 44.0
			rightButton.isHidden = true
		case .onlyTextField:
			buttonWidth.constant = 22.0
			rightButton.isHidden = true
		}
		
		contentView.setNeedsLayout()
	}
	
	private func handle(isShowRedAlert: Bool) {
		let color = evaluate(isShowRedAlert, ifTrue: UIColor.red, ifFalse: UIColor(named: "TextFieldBorderColor"))
		textField.layer.borderColor = color?.cgColor
		validationLabel.isHidden = !isShowRedAlert
		contentView.setNeedsLayout()
	}

}

extension TextFormCell: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		let result = props.formatter(textField.text ?? "")
		textField.text = result
		props.onEditText.perform(with: result)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		props.onEndEditing.perform(with: textField.text ?? "")
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return props.shouldEdit
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension TextFormCell.Props: Validatable {
	
}

protocol Validatable  {
	var canShowRedAlert: Bool { get set }
}

enum TextfieldMode {
	case full(icon: String)
	case withoutButton
	case onlyTextField
}
