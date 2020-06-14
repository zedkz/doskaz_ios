//
//  PostCollectionViewCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/14/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class PostCollectionViewCell: UICollectionViewCell {
	
	//MARK: - inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		style()
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapGR)
		PostCollectionViewCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			textLabel.text = props.blog.title
			let url = props.blog.imagURL
			imageView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
			imageView.kf.indicatorType = .activity
			imageView.kf.setImage(
				with: url,
				options: [
					.scaleFactor(UIScreen.main.scale),
					.transition(.fade(1)),
					.cacheOriginalImage
			])
		}
	}
	
	let imageView = UIImageView()
	let textLabel = UILabel()
	
	//MARK: - Private
	
	private func style() {
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = .white
		textLabel.decorate(with: Style.systemFont(size: 12), { label in
			label.numberOfLines = 0
		})
	}
	
	@objc func handleTap() {
		props.onPickImage.perform()
	}
	
	// MARK: - Subtypes
	
	struct Props {
		var blog: Item
		var onPickImage: Command = .nop
	}
	
}

struct PostCollectionViewCellLayout {
	weak var rv: PostCollectionViewCell!
	
	var stack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 12
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return stack
	}()
	
	func draw() {
		rv.contentView.addSubview(stack)
		stack.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
		stack.addArrangedSubview(rv.imageView)
		stack.addArrangedSubview(rv.textLabel)
		rv.imageView.addConstraintsProgrammatically
			.set(my: .height, .equal, to: .width, of: rv.imageView, times: 128/224)
		
	}
	
}


