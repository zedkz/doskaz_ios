//
//  AwardsCollectionViewCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class AwardsCollectionViewCell: UICollectionViewCell {
	
	//MARK: - inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		style()
		AwardsCollectionViewCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			textLabel.text = props.heading
			imageView.image = UIImage(named: props.imageName)
		}
	}
	
	let imageView = UIImageView()
	let textLabel  = UILabel()
	
	//MARK: - Private
	
	private func style() {
		backgroundColor = .systemYellow
		textLabel.numberOfLines = 0
		textLabel.font = .systemFont(ofSize: 14)
		
		imageView.contentMode = .scaleAspectFit
	}
	
	// MARK: - Subtypes
	
	struct Props {
		let heading: String
		let imageName: String
	}
	
}

struct AwardsCollectionViewCellLayout {
	weak var rv: AwardsCollectionViewCell!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension AwardsCollectionViewCellLayout {
	
	func addSubviews() {
		rv.addSubview(rv.textLabel)
		rv.addSubview(rv.imageView)
	}
	
	func addConstraints() {
		rv.imageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 10)
			.pinEdgeToSupers(.bottom)
			.pinEdgeToSupers(.leading)
			.set(my: .height, to: 48)
			.set(my: .width, to: 48)
		
		rv.textLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pin(my: .leading, to: .trailing, of: rv.imageView, plus: 8)
			.pinEdgeToSupers(.trailing, plus: -4)
			.pinEdgeToSupers(.bottom)
	}
	
}
