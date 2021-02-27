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
	
	func uploadImage(_ image: UIImage) {
		guard let data = image.jpegData(compressionQuality: 0.8) else {
			return
		}
			
		let onSuccess = { [weak self] (uploadResponse: UploadResponse) -> Void in
			if let path = uploadResponse.path {
				self?.add(photos: [path])
			}
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			print(error.localizedDescription)
		}
		
		APIUpload(onSuccess: onSuccess, onFailure: onFailure, image: data).dispatch()
	}
	
	func add(photos: [String]) {
		guard let id = id else {
			return
		}
		
		AddPhotosRequest(objectId: id, params: AddPhotosRequest.Params(photos: photos)) { [weak self] _ in
			print("photo added")
			self?.close()
		} onFailure: { error in
			print(error.localizedDescription)
		}
		.dispatch()
	}
}


extension PhotoUploaderViewController: ImagePickerDelegate {
	func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		imagePicker.resetAssets()
	}
	
	func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		if let image = images.first {
			uploadImage(image)
		}
	}
	
	func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
		close()
	}
}


