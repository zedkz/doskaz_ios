//
//  ProfileView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/18/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileView: UIView {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		//MARK: - Configure constant data
		//MARK: - Configure style
		avatarImageView.backgroundColor = .purple
		title.backgroundColor = .yellow
		title.text = "kudaibergenov almas"
		
		//MARK: - Configure behavior
		//MARK: - Layout
		addSubview(mainStack)
		mainStack.addConstraintsProgrammatically
			.pinToSuper()
		
		mainStack.addArrangedSubview(mainInfoContainer)
		
		mainInfoContainer.addSubview(avatarImageView)
		mainInfoContainer.addSubview(title)
		
		mainInfoContainer.addConstraintsProgrammatically
			.set(my: .height, .greaterThanOrEqual, to: 80)
		avatarImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.set(my: .width, to: 80)
			.set(my: .height, to: 80)
		title.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.trailing)
//			.pinEdgeToSupers(.bottom)
			.pin(my: .leading, to: .trailing, of: avatarImageView, plus: 10)
	}
	
	//MARK: - Public properties and methods
	let mainInfoContainer = UIView()
	let avatarImageView = UIImageView()
	let title = UILabel()

	let mainStack: UIStackView = {
		let s = UIStackView()
		s.axis = .vertical
		s.isLayoutMarginsRelativeArrangement = true
		s.layoutMargins = UIEdgeInsets(all: 10)
		return s
	}()
	
	//MARK: - Sub types
	
}

