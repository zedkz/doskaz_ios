//
//  CollectionViewDataSource.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

/// Data source class for section of the
/// collection view. It also registers the cell
/// needed for dequeuing
class CollectionViewDataSource<Props, Cell>: NSObject, UICollectionViewDataSource where Cell: UICollectionViewCell {
	
	typealias CellConfigurator = (Props, Cell) -> Void
	
	var cellsProps: [Props]
	private let reuseIdentifier: String
	private let cellConfigurator: CellConfigurator
	
	init(_ collectionView: UICollectionView,
			 cellsProps: [Props] = [Props](),
			 reuseIdentifier: String = Cell.reuseIdentifier,
			 cellConfigurator: @escaping CellConfigurator) {
		collectionView.register(Cell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.cellsProps = cellsProps
		self.reuseIdentifier = reuseIdentifier
		self.cellConfigurator = cellConfigurator
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cellsProps.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		let customCell = reusableCell as! Cell
		cellConfigurator(cellsProps[indexPath.row], customCell)
		return reusableCell
	}
}

/// Data source class for all the sections of the
/// collection view. It's made my combining CollectionViewDataSource
class SectionedCollectionViewDataSource: NSObject {
	private let dataSources: [UICollectionViewDataSource]
	
	init(dataSources: [UICollectionViewDataSource]) {
		self.dataSources = dataSources
	}
}

extension SectionedCollectionViewDataSource: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return dataSources.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let dataSource = dataSources[section]
		return dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let dataSource = dataSources[indexPath.section]
		let indexPath = IndexPath(row: indexPath.row, section: 0)
		return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
	}
	
}

extension UICollectionViewCell {
	static var reuseIdentifier: String {
		return String(describing: Self.self)
	}
}
