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
	var paths = [String]()
	
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
	
	func uploadImage(_ image: UIImage, group: DispatchGroup) {
		guard let data = image.jpegData(compressionQuality: 0.8) else {
			return
		}
			
		let onSuccess = { [weak self] (uploadResponse: UploadResponse) -> Void in
			group.leave()
			if let path = uploadResponse.path {
				self?.paths.append(path)
			}
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			group.leave()
			print(error.localizedDescription)
		}
		
		group.enter()
		APIUpload(onSuccess: onSuccess, onFailure: onFailure, image: data).dispatch()
	}
	
	func add(photos: [String]) {
		guard let id = id else {
			return
		}
		
		AddPhotosRequest(objectId: id, params: AddPhotosRequest.Params(photos: photos)) { [weak self] _ in
			print("photo added")
			guard let self = self else {
				return
			}
			
			GenericAlertPresenter(title: l10n(.succeedFormMessage), actions: [Action(title: "OK") {
				self.close()
			}])
			.present(in: self)
			
		} onFailure: { [weak self] error in
			print(error.localizedDescription)
			self?.paths.removeAll()
		}
		.dispatch()
	}
}


extension PhotoUploaderViewController: ImagePickerDelegate {
	func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		imagePicker.resetAssets()
	}
	
	func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		let group = DispatchGroup()
		
		images.forEach { image in
			uploadImage(image, group: group)
		}

		group.notify(queue: .main) { [weak self] in
			guard let self = self else {
				return
			}
			
			self.add(photos: self.paths)
		}
	}
	
	func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
		close()
	}
}


