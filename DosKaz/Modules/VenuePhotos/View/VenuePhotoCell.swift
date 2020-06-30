//
//  VenuePhotoCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/27/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class VenuePhotoCell: UICollectionViewCell {
	
	//MARK: - inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		style()
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapGR)
		VenuePhotoCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			let url = URL(string: Constants.mainURL + props.image)
			imageView.kf.indicatorType = .activity
			imageView.kf.setImage(
				with: url,
				options: [
					.scaleFactor(UIScreen.main.scale),
					.transition(.fade(1)),
					.cacheOriginalImage
			])
			imageView.setupImageViewer(
				urls: props.urls,
				initialIndex: props.index,
				options: [
					.theme(.dark)
				]
			)
		}
	}
	
	let imageView = UIImageView()
	
	//MARK: - Private
	
	private func style() {
		imageView.contentMode = .scaleAspectFit
	}
	
	@objc func handleTap() {
		props.onPickImage.perform()
	}
	
	// MARK: - Subtypes
	
	struct Props {
		let image: String
		let index: Int
		var urls: [URL]
		var onPickImage: Command = .nop
	}
	
}

struct VenuePhotoCellLayout {
	weak var rv: VenuePhotoCell!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension VenuePhotoCellLayout {
	
	func addSubviews() {
		rv.addSubview(rv.imageView)
	}
	
	func addConstraints() {
		rv.imageView.addConstraintsProgrammatically
			.pinToSuper()
	}
	
}

