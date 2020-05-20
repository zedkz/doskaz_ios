//
//  PhotoPickerCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class PhotoPickerCell: UITableViewCell, Updatable {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		//MARK: - Configure constant data
		titleLabel.text = l10n(.loadPhoto)
		
		//MARK: - Configure style
		collectionView.backgroundColor = .white
		
		//MARK: - Configure behavior
		configureCollectionView()
		
		//MARK: - Layout
		contentView.addSubview(titleLabel)
		contentView.addSubview(collectionView)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading, plus: 22)
			.pinEdgeToSupers(.trailing)
		
		collectionView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 8)
			.pinEdgeToSupers(.leading, plus: 22)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
			.set(my: .height, to: 80)
		
	}
	
	//MARK: - Public properties and methods
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	let titleLabel = UILabel()
	
	var props: Props!
	
	//MARK: - Sub types
	struct Props { }
	
	//MARK: - Privates
	private var collectionDataSource: CollectionViewDataSource<PhotoPickerCollectionViewCell.Props,PhotoPickerCollectionViewCell>!
	
	private func configureCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 80, height: 80)
		flowLayout.minimumInteritemSpacing = 10
		collectionView.collectionViewLayout = flowLayout
		collectionView.alwaysBounceHorizontal = true
		collectionView.showsHorizontalScrollIndicator = false
				
		collectionDataSource = CollectionViewDataSource(collectionView) { $1.props = $0 }
		let cellsProps = Array(
			repeating: PhotoPickerCollectionViewCell.Props(imageName: "mapobject_40_partially_available"),
			count: 9
		)
		collectionDataSource.cellsProps = cellsProps
		collectionView.dataSource = collectionDataSource
	}
	
}

//MARK: - PhotoPickerCollectionViewCell

class PhotoPickerCollectionViewCell: UICollectionViewCell {
	
	//MARK: - inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		style()
		PhotoPickerCollectionViewCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			imageView.image = UIImage(named: props.imageName)
		}
	}
	
	let imageView = UIImageView()
	
	//MARK: - Private
	
	private func style() {
		imageView.contentMode = .scaleAspectFit
	}
	
	// MARK: - Subtypes
	
	struct Props {
		let imageName: String
	}
	
}

struct PhotoPickerCollectionViewCellLayout {
	weak var rv: PhotoPickerCollectionViewCell!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension PhotoPickerCollectionViewCellLayout {
	
	func addSubviews() {
		rv.addSubview(rv.imageView)
	}
	
	func addConstraints() {
		rv.imageView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, to: 80)
			.set(my: .width, to: 80)
	}
	
}
