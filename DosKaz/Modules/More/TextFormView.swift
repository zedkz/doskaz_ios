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
		set(height: 40)
	}
	
	init(height: CGFloat) {
		super.init(frame: .zero)
		set(height: height)
	}
	
	func set(height: CGFloat) {

		//MARK: - Configure text field left padding
				
		//MARK: - Configure constant data
		titleLabel.text = "-"
		titleLabel.numberOfLines = 0
		validationLabel.text = l10n(.fillTheField)
		validationLabel.numberOfLines = 0
		
		//MARK: - Configure style
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
		
		//MARK: - Layout
		addSubview(titleLabel)
		addSubview(textField)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 12)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
		
		textField.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 8)
			.pin(my: .leading, andOf: titleLabel)
			.set(my: .height, to: height)
			.pin(my: .trailing, andOf: titleLabel)
			.pinEdgeToSupers(.bottom, plus: -8)
	}
	
	//MARK: - Public properties and methods
	let titleLabel = UILabel()
	let textField = UITextViewPadding()
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

extension TextFormView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		let result = props.formatter(textView.text)
		textField.text = result
		props.onEditText.perform(with: result)
	}

}

extension TextFormView.Props: Validatable {
	
}


class UITextViewPadding : UITextView {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		textContainerInset = UIEdgeInsets(top: 12, left: 4, bottom: 0, right: 4)
	}
}
