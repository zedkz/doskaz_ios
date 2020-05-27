//
//  VenueCollectionDelegate.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/27/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class VenueCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
		
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.frame.width - 4) / 3
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return sectionInsets
	}
	
}
