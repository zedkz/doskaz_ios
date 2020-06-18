//
//  AuthInfoView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/18/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class AuthInfoView: UIView {
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	let imageView = UIImageView()
	let textLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		imageView.contentMode = .center
		textLabel.decorate(with: Style.systemFont(size: 12, weight: .semibold))
		textLabel.numberOfLines = 0
		layout()
	}
	
	private func layout() {
		addSubview(imageView)
		addSubview(textLabel)
		
		imageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 8)
			.pinEdgeToSupers(.top, plus: 8)
			.pinEdgeToSupers(.bottom, plus: -8)
		
		textLabel.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: imageView, plus: 16)
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
		
		imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
	}
	
	var props: Props! {
		didSet {
			imageView.image = UIImage(named: props.imageName)
			textLabel.text = props.text
			textLabel.textColor = props.textColor
		}
	}
	
	struct Props {
		let imageName: String
		let text: String
		var textColor: UIColor = .black
	}
	
}

