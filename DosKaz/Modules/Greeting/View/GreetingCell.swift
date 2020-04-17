//
//  GreetingCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class GreetingCell: UICollectionViewCell {
	
	//MARK: - inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		style()
		GreetingCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			guard let props = props else { return }
			heading.text = props.heading
			mainText.text = props.mainText
			topImage.image = UIImage(named: props.imageName)
		}
	}
	
	let topImage = UIImageView()
	let heading  = UILabel()
	let mainText = UILabel()
	
	//MARK: - Private
		
	private func style() {
		heading.numberOfLines = 0
		heading.textAlignment = .center
		heading.font = .systemFont(ofSize: 20, weight: .semibold)

		mainText.numberOfLines = 0
		mainText.textAlignment = .center
		mainText.font = .systemFont(ofSize: 14, weight: .regular)
		
		topImage.contentMode = .scaleAspectFit
	}
	
	// MARK: - Subtypes
	
	struct Props {
		let heading: String
		let mainText: String
		let imageName: String
	}
		
}

struct GreetingCellLayout {
	weak var rv: GreetingCell!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension GreetingCellLayout {
	
	func addSubviews() {
		rv.addSubview(rv.heading)
		rv.addSubview(rv.topImage)
		rv.addSubview(rv.mainText)
	}
	
	func addConstraints() {
		rv.heading.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.pin(my: .top, to: .bottom, of: rv.topImage, plus: 16)
		
		rv.topImage.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 22)
			.pinEdgeToSupers(.horizontalCenter)
			.set(my: .height, to: 90)
		
		rv.mainText.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.pin(my: .top, to: .bottom, of: rv.heading, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -16)
			.pinEdgeToSupers(.leading, plus: 16)
	}
	
}
