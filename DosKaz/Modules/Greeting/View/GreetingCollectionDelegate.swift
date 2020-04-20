//
//  GreetingCollectionDelegate.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class GreetingCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
	
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
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return sectionInsets
	}
	
}
