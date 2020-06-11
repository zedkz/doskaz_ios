//
//  ContactInfoView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/11/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ContactInfoView: UIView {
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	let imageView = UIImageView()
	let textLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		textLabel.decorate(with: Style.systemFont(size: 14, weight: .semibold))
		layout()
	}
	
	private func layout() {
		addSubview(imageView)
		addSubview(textLabel)
		
		imageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 8)
			.pinEdgeToSupers(.verticalCenter)
		
		textLabel.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: imageView, plus: 24)
			.pinEdgeToSupers(.top, plus: 16)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom, plus: -16)
		
		imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
	}
	
	var props: Props! {
		didSet {
			imageView.image = UIImage(named: props.imageName)
			textLabel.text = props.text
		}
	}
	
	struct Props {
		let imageName: String
		let text: String
	}
	
}
