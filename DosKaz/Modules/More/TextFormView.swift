//
//  TextFormView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/11/20.
//  Copyright © 2020 zed. All rights reserved.
//


import SharedCodeFramework

class TextFormView: UIView {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
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
		textField.delegate = self
		textField.addTarget(self, action: #selector(handleTextfield), for: .editingChanged)
		
		//MARK: - Layout
		addSubview(titleLabel)
		addSubview(textField)
		addSubview(validationLabel)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 12)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
		
		textField.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 8)
			.pin(my: .leading, andOf: titleLabel)
			.set(my: .height, to: 40)
			.pin(my: .trailing, andOf: titleLabel)

		validationLabel.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: textField, plus: 2)
			.pin(my: .leading, andOf: titleLabel)
			.pin(my: .trailing, andOf: titleLabel)
			.pinEdgeToSupers(.bottom, plus: -8)
	}
	
	//MARK: - Public properties and methods
	let titleLabel = UILabel()
	let textField = UITextField()
	let validationLabel = UILabel()
	
	var props: Props! {
		didSet {
			textField.text = props.text
			handle(isShowRedAlert: props.canShowRedAlert)
			titleLabel.text = props.title
		}
	}
	
	//MARK: - Sub types
	struct Props {
		var canShowRedAlert: Bool = false
		var text: String
		var title: String
		var onEditText: Text = .nop
		var formatter: (String) -> String = { input in return input }
	}
	
	//MARK: - Private
	
	@objc func handleTextfield(_ textField: UITextField) {
		let result = props.formatter(textField.text ?? "")
		textField.text = result
		props.onEditText.perform(with: result)
	}
	
	private func handle(isShowRedAlert: Bool) {
		let color = evaluate(isShowRedAlert, ifTrue: UIColor.red, ifFalse: UIColor(named: "TextFieldBorderColor"))
		textField.layer.borderColor = color?.cgColor
		let textColor = evaluate(isShowRedAlert, ifTrue: UIColor.black, ifFalse: .clear)
		validationLabel.textColor = textColor
	}
	
}

extension TextFormView: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		let result = props.formatter(textField.text ?? "")
		textField.text = result
		props.onEditText.perform(with: result)
	}
		
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension TextFormView.Props: Validatable {
	
}

