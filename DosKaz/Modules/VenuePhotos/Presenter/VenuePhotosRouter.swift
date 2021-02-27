//
//  VenuePhotosRouter.swift
//  VenuePhotos
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-27 10:33:42 +0000 lobster.kz. All rights reserved.
//

import UIKit

protocol VenuePhotosRouterInput {
	func showPhotoUploader(with viewController: UIViewController, id: Int?, on onDismiss: @escaping () -> Void)
}

// MARK: Implementation

class VenuePhotosRouter: VenuePhotosRouterInput {
	func showPhotoUploader(with viewController: UIViewController, id: Int?, on onDismiss: @escaping () -> Void) {
		let photoUploader = PhotoUploaderViewController()
		photoUploader.onDismiss = onDismiss
		photoUploader.id = id
		let nav = UINavigationController(rootViewController: photoUploader)
		viewController.present(nav, animated: true, completion: nil)
	}
}
