//
//  RegionalRepCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/13/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class RegionalRepCell: UITableViewCell, Updatable {
	
	let mainContainer = UIView()

	let avatarImageView = UIImageView()
	let title = UILabel()
	let statusTitle = UILabel()
	let line = UIView()
	let mailButton = UIButton(type: .system)
	let phoneButton = UIButton(type: .system)
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		title.decorate(with: Style.systemFont(size: 14, weight: .semibold))
		statusTitle.decorate(with: Style.systemFont(size: 10), { lab in
			lab.textColor = .gray
			lab.numberOfLines = 0
		})
		line.backgroundColor = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 0.2)
		mailButton.setImage(UIImage(named: "mail_1"), for: .normal)
		phoneButton.setImage(UIImage(named: "phone_call_1"), for: .normal)
		
		avatarImageView.layer.cornerRadius = 56/2
		avatarImageView.clipsToBounds = true
		avatarImageView.backgroundColor = UIColor.white
		avatarImageView.contentMode = .scaleAspectFit
		
		contentView.addSubview(mainContainer)
		mainContainer.addSubview(avatarImageView)
		mainContainer.addSubview(title)
		mainContainer.addSubview(statusTitle)
		mainContainer.addSubview(line)
		mainContainer.addSubview(mailButton)
		mainContainer.addSubview(phoneButton)
		
		mainContainer.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .height, .greaterThanOrEqual, to: 88)
		
		avatarImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 16)
			.pinEdgeToSupers(.leading)
			.set(my: .width, to: 56)
			.set(my: .height, to: 56)
		title.addConstraintsProgrammatically
			.pin(my: .top, andOf: avatarImageView)
			.pin(my: .leading, to: .trailing, of: avatarImageView, plus: 10)
		statusTitle.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: title, plus: 4)
			.pin(my: .trailing, andOf: title)
			.pin(my: .leading, to: .trailing, of: avatarImageView, plus: 10)
			.set(my: .bottom, .lessThanOrEqual, to: .top, of: line, plus: -8)
		
		phoneButton.addConstraintsProgrammatically
			.pin(my: .top, andOf: title)
			.pin(my: .leading, to: .trailing, of: title, plus: 4)
		mailButton.addConstraintsProgrammatically
			.pin(my: .top, andOf: title)
			.pinEdgeToSupers(.trailing)
			.pin(my: .leading, to: .trailing, of: phoneButton, plus: 20)
		
		phoneButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		mailButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		line.addConstraintsProgrammatically
			.pin(my: .leading, andOf: title)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
			.set(my: .height, to: 1)
	}
	
	
	var props: Props! {
		didSet {
			let url = props.regionalRep.imageURL
			avatarImageView.kf.indicatorType = .activity
			avatarImageView.kf.setImage(
				with: url,
				options: [
					.scaleFactor(UIScreen.main.scale),
					.transition(.fade(1)),
					.cacheOriginalImage
			])
			title.text = props.regionalRep.name
			statusTitle.text = props.regionalRep.department
		}
	}
	
	struct Props {
		var regionalRep: RegionalRep
	}
	
}

