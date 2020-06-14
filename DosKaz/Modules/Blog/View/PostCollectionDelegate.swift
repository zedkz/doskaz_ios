//
//  PostCollectionDelegate.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/14/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class PostCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
		
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 2/3, height: collectionView.frame.height)
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 16
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		let sectionInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 8)
		return sectionInsets
	}
	
}
