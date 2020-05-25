//
//  PhotoPickerCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

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
	
	var props: Props! {
		didSet {
			update(props.images)
		}
	}
	
	//MARK: - Sub types
	struct Props {
		var images = [UIImage]()
		var onPick: Command = .nop
	}
	
	//MARK: - Privates
	private var collectionDataSource: CollectionViewDataSource<PhotoPickerCollectionViewCell.Props,PhotoPickerCollectionViewCell>!
	
	private func configureCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 80, height: 80)
		flowLayout.minimumLineSpacing = 30
		collectionView.collectionViewLayout = flowLayout
		collectionView.alwaysBounceHorizontal = true
		collectionView.showsHorizontalScrollIndicator = false
				
		collectionDataSource = CollectionViewDataSource(collectionView) { $1.props = $0 }
		collectionView.dataSource = collectionDataSource
	}
	
	private func update(_ images: [UIImage]) {
		let pickerCell = PhotoPickerCollectionViewCell.Props(
			image: UIImage(named: "add_object")!, onPickImage: Command {
				self.props.onPick.perform()
			}
		)
		
		let imageCollectionViewCells = images.map { image in
			return PhotoPickerCollectionViewCell.Props(
				image: image
			)
		}
		
		var allCells = [PhotoPickerCollectionViewCell.Props]()
		allCells.append(pickerCell)
		allCells.append(contentsOf: imageCollectionViewCells)
		
		collectionDataSource.cellsProps = allCells
		collectionView.reloadData()
	}
	
}

//MARK: - PhotoPickerCollectionViewCell

class PhotoPickerCollectionViewCell: UICollectionViewCell {
	
	//MARK: - inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		style()
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapGR)
		PhotoPickerCollectionViewCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			imageView.image = props.image
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
		let image: UIImage
		var onPickImage: Command = .nop
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
