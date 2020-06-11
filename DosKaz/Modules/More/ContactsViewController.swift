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
		
		topImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.top)
		roundedView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: label1, plus: 32)
			.set(my: .height, to: 24)
	}
	
	private func configureData() {
		topImageView.image = UIImage(named: "green_map_background")
		label1.text = l10n(.contactsInfo)
	}
	
	private func configureStyle() {
		topImageView.contentMode = .scaleToFill
		label1.decorate(with: Style.systemFont(size: 14), { label in
			label.numberOfLines = 0
			label.textColor = .white
		})
	}
	
}
