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
		renderConstantData()
		style()
		GreetingCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	let topImage = UIImageView()
	let heading  = UILabel()
	let mainText = UILabel()
	
	//MARK: - Private
	
	private func renderConstantData() {
		heading.text = "Проверьте доступность"
		mainText.text = "Доступность объектов обозначена системой светофора: зеленая иконка обозначает полностью доступные объекты, желтая — частично доступные, красная — недоступные объекты."
		topImage.image = UIImage(named: "greetin_icon_page_one")
	}
	
	private func style() {
		heading.numberOfLines = 0
		heading.textAlignment = .center
		heading.font = .systemFont(ofSize: 20, weight: .semibold)

		mainText.numberOfLines = 0
		mainText.textAlignment = .center
		mainText.font = .systemFont(ofSize: 14, weight: .regular)
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
			.pinEdgeToSupers(.top, plus: 32)
			.pinEdgeToSupers(.horizontalCenter)
		
		rv.mainText.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.pin(my: .top, to: .bottom, of: rv.heading, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -16)
			.pinEdgeToSupers(.leading, plus: 16)
	}
	
}
