//
//  PhotoUploaderViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/27/21.
//  Copyright © 2021 zed. All rights reserved.
//

import UIKit

class PhotoUploaderViewController: UIViewController {
	var onDismiss: () -> Void = { }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		navigationItem.title = l10n(.photo)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: l10n(.close), style: .done, target: self, action: #selector(close))
	}
	
	@objc func close() {
		dismiss(animated: true) { [weak self] in
			self?.onDismiss()
		}
	}
}

