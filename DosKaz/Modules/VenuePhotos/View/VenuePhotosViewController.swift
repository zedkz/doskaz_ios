//
//  VenuePhotosViewController.swift
//  VenuePhotos
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-27 10:33:42 +0000 lobster.kz. All rights reserved.
//

import UIKit
import SharedCodeFramework

// MARK: View input protocol

protocol VenuePhotosViewInput where Self: UIViewController {
	func setupInitialState()
	func update(_ photos: [Photo])
}

class VenuePhotosViewController: UIViewController, VenuePhotosViewInput {
	
	var output: VenuePhotosViewOutput!
	
	private let titleLabel = UILabel()
	
	private let collectionView = ContentSizedCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private var collectionDataSource: CollectionViewDataSource<VenuePhotoCell.Props,VenuePhotoCell>!
	private var delegate = VenueCollectionDelegate()
	
	func setupInitialState() {
		view.backgroundColor = .white
		view.addSubview(titleLabel)
		view.addSubview(collectionView)
		collectionView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 10)
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.bottom, plus: -16)
			.set(my: .height, .greaterThanOrEqual, to: 90)
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.top, plus: 16)
		
		titleLabel.text = l10n(.photo).uppercased()
		titleLabel.decorate(with: Style.systemFont(size: 14, weight: .bold))
		
		configureCollectionView()
	}
	
	private func configureCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		collectionView.collectionViewLayout = flowLayout
		collectionView.alwaysBounceVertical = true
		collectionView.showsVerticalScrollIndicator = true
		collectionView.backgroundColor = .white
		collectionView.delegate = delegate
		collectionDataSource = CollectionViewDataSource(collectionView) { $1.props = $0 }
		collectionView.dataSource = collectionDataSource
	}
	
	func update(_ photos: [Photo]) {

		let imageCollectionViewCells: [VenuePhotoCell.Props] = photos.map { (photo: Photo) in
			return VenuePhotoCell.Props(
				image: photo.previewUrl
			)
		}
		
		var allCells = [VenuePhotoCell.Props]()
		
		allCells.append(contentsOf: imageCollectionViewCells)
		
		collectionDataSource.cellsProps = allCells
		collectionView.reloadData()
	}
}

// MARK: Life cycle

extension VenuePhotosViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}

}
