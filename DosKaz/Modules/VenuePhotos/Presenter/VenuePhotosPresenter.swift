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
}

// MARK: ViewController output protocol

protocol VenuePhotosViewOutput {
	func viewIsReady()
	func initView(with photos: [Photo])
}

extension VenuePhotosPresenter: VenuePhotosViewOutput {
	
	func initView(with photos: [Photo]) {
		var testPhotos = photos
		testPhotos.append(Photo(previewUrl: "/storage/63f586967633f1a0de0462d8a7e58cfb.jpeg", viewUrl: "", date: ""))
		testPhotos.append(Photo(previewUrl: "/storage/63f586967633f1a0de0462d8a7e58cfb.jpeg", viewUrl: "", date: ""))
		testPhotos.append(Photo(previewUrl: "/storage/63f586967633f1a0de0462d8a7e58cfb.jpeg", viewUrl: "", date: ""))
		testPhotos.append(Photo(previewUrl: "/storage/63f586967633f1a0de0462d8a7e58cfb.jpeg", viewUrl: "", date: ""))
		self.photos = testPhotos
	}
	
	func viewIsReady() {
		view.setupInitialState()
		view.update(photos)
	}

}

// MARK: Interactor output protocol

protocol VenuePhotosInteractorOutput: class {

}

extension VenuePhotosPresenter: VenuePhotosInteractorOutput {

}
