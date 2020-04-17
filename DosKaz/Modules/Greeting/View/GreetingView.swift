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
		configureSubviews()
		GreetingViewLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	let backgroundImage = UIImageView()
	let logoImage				= UIImageView()
	let whiteBackground = UIView()
	let collectionView	= UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
	
	//MARK: - Private

	private var collectionDataSource: CollectionViewDataSource<String, GreetingCell>!
	private let collectionDelegate = GreetingCollectionDelegate()
	
	private func renderConstantData() {
		backgroundImage.image = UIImage(named:"green_map_background")
		logoImage.image = UIImage(named: "logo")
	}
	
	private func style() {
		logoImage.contentMode = .scaleAspectFit
		whiteBackground.decorate(with: Style.topCornersRounded)
		collectionView.backgroundColor = .white
	}
	
	private func configureSubviews() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		collectionView.collectionViewLayout = flowLayout
		collectionView.isPagingEnabled = true
		collectionView.alwaysBounceHorizontal = true
		collectionView.showsHorizontalScrollIndicator = false
		
		
		collectionDataSource = CollectionViewDataSource(collectionView) { text, cell in
			
		}
		collectionDataSource.cellsProps = ["1", "2", "3"]
		collectionView.dataSource = collectionDataSource
		collectionView.delegate = collectionDelegate
		
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
		rv.addSubview(rv.collectionView)
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
		
		rv.collectionView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
			.pin(my: .top, andOf: rv.whiteBackground, plus: 15)
	}
	
}
