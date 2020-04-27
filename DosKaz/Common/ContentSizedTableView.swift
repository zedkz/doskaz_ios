//
//  ContentSizedTableView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/27/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

final class ContentSizedTableView: UITableView {
	override var contentSize:CGSize {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}
}
