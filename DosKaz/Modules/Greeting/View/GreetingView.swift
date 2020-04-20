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
	let backButton = Button(type: .system)
	let nextButton = Button(type: .system)
	let pageControl = UIPageControl()
	
	//MARK: - Private

	private var collectionDataSource: CollectionViewDataSource<GreetingCell.Props, GreetingCell>!
	private let collectionDelegate = GreetingCollectionDelegate()
	
	private func renderConstantData() {
		backgroundImage.image = UIImage(named:"green_map_background")
		logoImage.image = UIImage(named: "logo")
		backButton.setTitle("Назад", for: .normal)
		nextButton.setTitle("Далее", for: .normal)
		pageControl.numberOfPages = 3
	}
	
	private func style() {
		logoImage.contentMode = .scaleAspectFit
		whiteBackground.decorate(with: Style.topCornersRounded)
		collectionView.backgroundColor = .white
		
		pageControl.pageIndicatorTintColor = .systemGray
		pageControl.currentPageIndicatorTintColor = .systemBlue
	}
	
	private func configureSubviews() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		collectionView.collectionViewLayout = flowLayout
		collectionView.isPagingEnabled = true
		collectionView.alwaysBounceHorizontal = true
		collectionView.showsHorizontalScrollIndicator = false
		
		
		collectionDataSource = CollectionViewDataSource(collectionView) { props, cell in
			cell.props = props
		}
		
		let cellsProps: [GreetingCell.Props] = [
			.init(heading: l10n(.greetingHeading1),
						mainText: l10n(.greeting1),
						imageName: "greetin_icon_page_one"),
			.init(heading: l10n(.greetingHeading2),
						mainText: l10n(.greeting2),
						imageName: "add_object"),
			.init(heading: l10n(.greetingHeading3),
						mainText: l10n(.greeting3),
						imageName: "greetin_icon_page_three")
		]
		collectionDataSource.cellsProps = cellsProps
		collectionView.dataSource = collectionDataSource
	
		collectionDelegate.didScrollToPage = { [pageControl, backButton] page in
			pageControl.currentPage = page
			backButton.isEnabled = (page != 0)
		}
		collectionView.delegate = collectionDelegate
		
		backButton.isEnabled = false
		backButton.didTouchUpInside = { [unowned self] in
			let previousPage = self.pageControl.currentPage - 1
			guard previousPage >= 0 else { return }
			self.collectionView.scrollToItem(at: IndexPath(item: previousPage, section: 0), at: .left, animated: true)
		}
		
		nextButton.didTouchUpInside = { [unowned self] in
			let nextPage = self.pageControl.currentPage + 1
			guard nextPage < 3 else { return }
			self.collectionView.scrollToItem(at: IndexPath(item: nextPage, section: 0), at: .left, animated: true)
		}
	
	}

}


struct GreetingViewLayout {
	weak var rv: GreetingView!
	
	let buttonStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
		return stack
	}()
	
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
		rv.addSubview(buttonStack)
		[rv.backButton, rv.pageControl, rv.nextButton]
			.forEach(buttonStack.addArrangedSubview)
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
			
			.pin(my: .top, andOf: rv.whiteBackground, plus: 15)
		
		buttonStack.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: rv.collectionView)
			.pinEdgeToSupers(.bottom, plus: -8)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.set(my: .height, to: 35)
	}
	
}
