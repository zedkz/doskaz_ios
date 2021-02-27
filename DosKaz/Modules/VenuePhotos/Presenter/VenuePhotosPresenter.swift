//
//  VenuePhotosPresenter.swift
//  VenuePhotos
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-27 10:33:42 +0000 lobster.kz. All rights reserved.
//
		
class VenuePhotosPresenter {
	
	weak var view: VenuePhotosViewInput!
	var interactor: VenuePhotosInteractorInput!
	var router: VenuePhotosRouterInput!

	var photos = [Photo]()
	var objectId: Int?
}

// MARK: ViewController output protocol

protocol VenuePhotosViewOutput {
	func viewIsReady()
	func viewWillAppear()
	func initView(with photos: [Photo], objectId: Int)
	func didPressAddPhotos()
}

extension VenuePhotosPresenter: VenuePhotosViewOutput {
	
	func initView(with photos: [Photo], objectId: Int) {
		self.objectId = objectId
		self.photos = photos
	}
	
	func viewIsReady() {
		view.setupInitialState()
		view.update(photos)
	}
	
	func viewWillAppear() {
		view.update(photos)
	}
	
	func didPressAddPhotos() {
		router.showPhotoUploader(with: view) {
			print("dismissed")
		}
	}

}

// MARK: Interactor output protocol

protocol VenuePhotosInteractorOutput: class {

}

extension VenuePhotosPresenter: VenuePhotosInteractorOutput {

}
