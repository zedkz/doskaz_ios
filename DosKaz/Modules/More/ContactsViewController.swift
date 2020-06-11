//
//  ContactsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		navigationItem.title = l10n(.contacts)
		configureLayout()
		configureData()
		configureStyle()
	}

	let topImageView = UIImageView()
	let roundedView: UIView = {
		let view = UIView()
		view.backgroundColor = .green
		view.decorate(with: Style.topCornersRounded)
		return view
	}()
	let label1 = UILabel()
	let mail = ContactInfoView()
	let phone = ContactInfoView()
	let facebook = ContactInfoView()
	let instagram = ContactInfoView()
	let writeUsLabel = UILabel()
	
	let scrollView = UIScrollView()
	
	var contentView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 10
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 43, left: 20, bottom: 20, right: 20)
		return stack
	}()
	
	private func configureLayout() {
		view.addSubview(scrollView)
		scrollView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		scrollView.addSubview(contentView)
		contentView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, .equal, to: .width, of: scrollView)
		
		contentView.addSubview(topImageView)
		contentView.addSubview(roundedView)
		contentView.addArrangedSubview(label1)
		contentView.setCustomSpacing(56, after: label1)
		contentView.addArrangedSubview(mail)
		contentView.addArrangedSubview(phone)
		contentView.addArrangedSubview(facebook)
		contentView.addArrangedSubview(instagram)
		contentView.setCustomSpacing(30, after: instagram)
		contentView.addArrangedSubview(writeUsLabel)
		
		topImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.top)
		roundedView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: label1, plus: 32)
			.pinEdgeToSupers(.bottom)
	}
	
	private func configureData() {
		topImageView.image = UIImage(named: "green_map_background")
		label1.text = l10n(.contactsInfo)
		mail.props = ContactInfoView.Props(imageName: "mail", text: "info@doskaz.kz")
		phone.props = ContactInfoView.Props(imageName: "phone_call", text: "8 (701) 346-21-77")
		facebook.props = ContactInfoView.Props(imageName: "facebook", text: "facebook.com/doskazkz")
		instagram.props = ContactInfoView.Props(imageName: "instagram", text: "instagram.com/doskaz.kz")
		writeUsLabel.text = l10n(.writeToUs)
	}
	
	private func configureStyle() {
		topImageView.contentMode = .scaleToFill
		label1.decorate(with: Style.systemFont(size: 14), { label in
			label.numberOfLines = 0
			label.textColor = .white
		})
		writeUsLabel.decorate(with: Style.systemFont(size: 20, weight: .semibold))
	}
	
}
