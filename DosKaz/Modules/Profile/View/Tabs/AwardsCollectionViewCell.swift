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
			.pinEdgeToSupers(.top, plus: 0)
			.pinEdgeToSupers(.bottom, plus: -0)
			.pinEdgeToSupers(.leading)
			.set(my: .width, .greaterThanOrEqual, to: 48)
			.set(my: .width, to: 48)
		
		rv.textLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pin(my: .leading, to: .trailing, of: rv.imageView, plus: 8)
			.pinEdgeToSupers(.trailing, plus: -4)
			.pinEdgeToSupers(.bottom)
	}
	
}


class AwardsCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
	
	var didScrollToPage: (Int) -> Void = { _ in }
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offSet = scrollView.contentOffset.x
		let width = scrollView.frame.width
		let horizontalCenter = width / 2
		
		let currentPage = Int(offSet + horizontalCenter) / Int(width)
		didScrollToPage(currentPage)
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let height = (collectionView.frame.height - 10*3)/4
		return CGSize(width: collectionView.frame.width * 2/3, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return sectionInsets
	}
	
}
