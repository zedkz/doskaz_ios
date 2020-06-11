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
		imageView.contentMode = .center
		textLabel.setBottomBorder()
		textLabel.decorate(with: Style.systemFont(size: 14, weight: .semibold))
		layout()
	}
	
	private func layout() {
		addSubview(imageView)
		addSubview(textLabel)
		
		imageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 8)
			.pinEdgeToSupers(.top, plus: 20)
			.pinEdgeToSupers(.bottom, plus: -20)
		
		textLabel.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: imageView, plus: 24)
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
		
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

fileprivate extension UIView {
	func setBottomBorder() {
		layer.backgroundColor = UIColor.white.cgColor
		layer.masksToBounds = false
		
		layer.shadowColor = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 0.2).cgColor
		layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		layer.shadowOpacity = 1.0
		layer.shadowRadius = 0.0
	}
}
