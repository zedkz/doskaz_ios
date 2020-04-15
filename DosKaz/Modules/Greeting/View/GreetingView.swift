//
//  GreetingView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class GreetingView: UIView {
	
	//MARK: -inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		renderConstantData()
		style()
		GreetingViewLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	//MARK: - Private
	
	let backgroundImage = UIImageView()
	let logoImage				= UIImageView()
	let whiteBackground = UIView()
	
	func renderConstantData() {
		backgroundImage.image = UIImage(named:"green_map_background")
		logoImage.image = UIImage(named: "logo")
	}
	
	func style() {
		logoImage.contentMode = .scaleAspectFit
		whiteBackground.decorate(with: Style.topCornersRounded)
	}

}


struct GreetingViewLayout {
	weak var rv: GreetingView!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension GreetingViewLayout {
	
	func addSubviews() {
		rv.addSubview(rv.backgroundImage)
		rv.addSubview(rv.logoImage)
		rv.addSubview(rv.whiteBackground)
	}
	
	func addConstraints() {
		rv.backgroundImage.addConstraintsProgrammatically
		.pinToSuper()
		
		rv.logoImage.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.pinEdgeToSupers(.top, plus: 51)
			.set(my: .width, to: 173)
		
		rv.whiteBackground.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.bottom)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: rv.logoImage, plus: 51)
	}
	
}
