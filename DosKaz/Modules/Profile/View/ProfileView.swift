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
		statusTitle.numberOfLines = 0
		title.numberOfLines = 0
		
		//MARK: - Configure style
		//fake begin
		avatarImageView.backgroundColor = .purple
		title.backgroundColor = .yellow
		title.text = "kudaibergenov almas"
		statusTitle.text = "almos gino enis kero fnec kops lojf aesc twnc dofe alsk adsf asdf zxcv esld esfs lopf ersd erds fdtr gfbv jknm vbfg dfsd"
		//fake end
		
		editButton.setTitle(l10n(.edit), for: .normal)
		editButton.decorate(with:
			Style.backgroundColor(color: UIColor(named: "VerifyInfoButton")),
			{ button in
				button.layer.cornerRadius = 2
				button.clipsToBounds = true
			}
		)
		
		//MARK: - Configure behavior
		//MARK: - Layout
		addSubview(mainStack)
		mainStack.addConstraintsProgrammatically
			.pinToSuper()
		
		mainStack.addArrangedSubview(mainInfoContainer)
		mainStack.addArrangedSubview(editButton)
		
		mainInfoContainer.addSubview(avatarImageView)
		mainInfoContainer.addSubview(title)
		mainInfoContainer.addSubview(statusTitle)
		
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
			.pin(my: .leading, to: .trailing, of: avatarImageView, plus: 10)
		statusTitle.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: title, plus: 8)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
			.pin(my: .leading, to: .trailing, of: avatarImageView, plus: 10)
		
		editButton.addConstraintsProgrammatically
			.set(my: .height, to: 40)
	}
	
	//MARK: - Public properties and methods
	//1
	let mainInfoContainer = UIView()
	let avatarImageView = UIImageView()
	let title = UILabel()
	let statusTitle = UILabel()

	//2
	let editButton = Button(type: .system)
	
	let mainStack: UIStackView = {
		let s = UIStackView()
		s.axis = .vertical
		s.spacing = 16
		s.isLayoutMarginsRelativeArrangement = true
		s.layoutMargins = UIEdgeInsets(all: 10)
		return s
	}()
	
	//MARK: - Sub types
	
}

