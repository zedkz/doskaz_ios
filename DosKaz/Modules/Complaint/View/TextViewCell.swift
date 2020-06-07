//
//  TextViewCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/24/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework
import UIKit

class TextViewCell: UITableViewCell, Updatable {
	
	//MARK: -inits

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		selectionStyle = .none
		
		//MARK: - Configure constant data
		titleLabel.numberOfLines = 0
		validationLabel.text = l10n(.fillTheField)
		validationLabel.numberOfLines = 0
		
		//MARK: - Configure style
		validationLabel.decorate(with: Style.systemFont(size: 12), { (label) in
			label.textColor = .red
		})
		
		textView.layer.borderWidth = 1
		textView.layer.borderColor = UIColor.black.cgColor
		
		placeHolderLabel.decorate(with: Style.systemFont(size: 11), { (label) in
			label.textColor = .gray
		})
		
		//MARK: - Configure behavior
		textView.delegate = self
		placeHolderLabel.isHidden = !textView.text.isEmpty
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
		titleLabel.addGestureRecognizer(tap)
		titleLabel.isUserInteractionEnabled = true
		
		//MARK: - Layout
		contentView.addSubview(titleLabel)
		contentView.addSubview(textView)
		contentView.addSubview(validationLabel)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 8)
			.pinEdgeToSupers(.leading, plus: 22)
			.pinEdgeToSupers(.trailing, plus: -22)
		
		textView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 8)
			.pinEdgeToSupers(.leading, plus: 22)
			.pinEdgeToSupers(.trailing, plus: -22)
			.set(my: .height, .greaterThanOrEqual, to: 80)
			
		validationLabel.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: textView, plus: 2)
			.pinEdgeToSupers(.leading, plus: 22)
			.pinEdgeToSupers(.trailing, plus: -22)
			.pinEdgeToSupers(.bottom, plus: -8)
		
		textView.addSubview(placeHolderLabel)
		
		placeHolderLabel.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(all:8))

	}
	
	@objc func handleLabelTap() {
		props?.onTitleTap.perform()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//MARK: - Public properties and methods
	
	let titleLabel = UILabel()
	let textView = UITextView()
	let validationLabel = UILabel()
	let placeHolderLabel = UILabel()
	
	var props: Props! {
		didSet {
			if let atrText = props.atrTitle {
				titleLabel.attributedText = atrText
			} else {
				titleLabel.text = props.title
			}
			placeHolderLabel.text = props.placeHolder
			textView.text = props.text
			placeHolderLabel.isHidden = !textView.text.isEmpty
			handle(shouldShowRedAlert: props.canShowRedAlert)
		}
	}

	//MARK: - Private
	private func handle(shouldShowRedAlert: Bool) {
		let color = evaluate(shouldShowRedAlert, ifTrue: UIColor.red, ifFalse: UIColor(named: "TextFieldBorderColor"))
		textView.layer.borderColor = color?.cgColor
		validationLabel.isHidden = !shouldShowRedAlert
		contentView.setNeedsLayout()
	}

	
	//MARK: - Sub types
	
	struct Props {
		var canShowRedAlert: Bool = false
		var title: String
		var atrTitle: NSAttributedString?
		var placeHolder: String
		var text: String
		var onEditText: Text = .nop
		var onTitleTap: Command = .nop
	}

}

extension TextViewCell: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		placeHolderLabel.isHidden = !textView.text.isEmpty
		props?.onEditText.perform(with: textView.text)
	}
}

extension TextViewCell.Props: Validatable { }
