//
//  PhotoUploaderViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/27/21.
//  Copyright © 2021 zed. All rights reserved.
//

import UIKit

class PhotoUploaderViewController: UIViewController {
	var id: Int?
	var onDismiss: () -> Void = { }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		navigationItem.title = l10n(.photo)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: l10n(.close), style: .done, target: self, action: #selector(close))
		
		let imagePickerController = ImagePickerController()
		imagePickerController.preferredImageSize = CGSize(width: 500, height: 500)
		imagePickerController.delegate = self
		
		addChild(imagePickerController)
		view.addSubview(imagePickerController.view)
		imagePickerController.view.addConstraintsProgrammatically
			.pinToSuper()
		imagePickerController.didMove(toParent: self)
	}
	
	@objc func close() {
		dismiss(animated: true) { [weak self] in
			self?.onDismiss()
		}
	}
}


extension PhotoUploaderViewController: ImagePickerDelegate {
	func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		imagePicker.resetAssets()
	}
	
	func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		print(images.count)

	}
	
	func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
		close()
	}
}


