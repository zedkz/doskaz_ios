//
//  TextViewCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/24/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell, Updatable {
	
	//MARK: -inits

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		//MARK: - Configure constant data
		validationLabel.text = l10n(.fillTheField)
		validationLabel.numberOfLines = 0
		
		//MARK: - Configure style
		validationLabel.decorate(with: Style.systemFont(size: 12), { (label) in
			label.textColor = .red
		})
		
		textView.layer.borderWidth = 1
		textView.layer.borderColor = UIColor.black.cgColor

		
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
		

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//MARK: - Public properties and methods
	
	let titleLabel = UILabel()
	let textView = UITextView()
	let validationLabel = UILabel()
	
	var props: Props! {
		didSet {
			titleLabel.text = props.title
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
		var placeHolder: String
	}

}

extension TextViewCell.Props: Validatable { }
