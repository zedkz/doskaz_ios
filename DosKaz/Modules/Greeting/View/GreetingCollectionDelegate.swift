//
//  GreetingCollectionDelegate.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class GreetingCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let width = collectionView.frame.width - (10 + 20/2)
		return CGSize(width: width, height: collectionView.frame.height - 30)
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		let sectionInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
		return sectionInsets
	}
	
}
