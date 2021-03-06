//
//  ComplaintPresenter.swift
//  Complaint
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-21 07:01:46 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework
		
class ComplaintPresenter {
	
	weak var view: ComplaintViewInput!
	var interactor: ComplaintInteractorInput!
	var router: ComplaintRouterInput!
	
	var objectId: Int!
	var objectName: String!
	
	var uploadedImagesURLs = [String]()

	var cities: [City]? { didSet { render() } }
	var complaintData: ComplaintData? { didSet { render() } }
	var authorities: [Authority]? { didSet { render() } }
	var complaintAtrs: [ComplaintAtr]? { didSet { render() } }
	
	func render() {
		if let cities = cities,
			let complaintData = complaintData,
			let authorities = authorities,
			let complaintAtrs = complaintAtrs {
			
			var complaintData = complaintData
			complaintData.objectId = objectId
			complaintData.content.objectName = objectName ?? ""
			view.showInitial(complaintData, cities, authorities, complaintAtrs)
		}
	}
}

// MARK: ViewController output protocol

protocol ComplaintViewOutput {
	func initWith(objectId: Int?, name: String?)
	func viewIsReady()
}

extension ComplaintPresenter: ComplaintViewOutput {
	
	func initWith(objectId: Int?, name: String?) {
		self.objectId = objectId
		self.objectName = name
	}
	
	func viewIsReady() {
		view.setupInitialState()
		view.onTouchReady = CommandWith<ComplaintData> { data in
			var copy = data
			copy.content.photos.append(contentsOf: self.uploadedImagesURLs)
			if data.content.comment.isEmpty {
				copy.content.comment = "Комменты"
			}
			self.interactor.submitComplaint(with: copy)
		}
		view.onPickImage = CommandWith<UIImage> { image in
			if let data = image.jpegData(compressionQuality: 0.8) {
				self.view.createSpinnerView()
				self.interactor.uploadImage(data)
			}
		}
		interactor.loadComplaintData()
		interactor.loadCities()
		interactor.loadAuthorities()
		interactor.loadComplaintAtrs()
	}

}

// MARK: Interactor output protocol

protocol ComplaintInteractorOutput: class {
	func didLoad(_ complaintData: ComplaintData)
	func didFailLoadComplaintData(with error: Error)
	func didLoad(_ cities: [City])
	func didFailLoadCities(with error: Error)
	func didLoad(_ authorities: [Authority])
	func didFailLoadAuthorities(with error: Error)
	func didLoad(_ complaintAtrs: [ComplaintAtr])
	func didFailLoadComplaintAtrs(with error: Error)
	func didSucceedSubmitForm()
	func didFailSubmitForm(with error: Error)
	func didLoadImage(with response: UploadResponse)
	func didFailLoadImage(with error: Error)
}

extension ComplaintPresenter: ComplaintInteractorOutput {
	func didLoadImage(with response: UploadResponse) {
		view.removeSpinner()
		print("Image uploaded",response)
		if let path = response.path {
			uploadedImagesURLs.append(path)
		}
	}
	
	func didFailLoadImage(with error: Error) {
		view.removeSpinner()
		print("didFailLoadImage",error)
	}
	
	func didSucceedSubmitForm() {
		view.displayAlert(with: l10n(.succeedFormMessage))
	}
	
	func didFailSubmitForm(with error: Error) {
		print("Failed complaint: ", error.localizedDescription)
		view.displayAlert(title: l10n(.errorMessage), message: error.localizedDescription)
	}
	
	func didLoad(_ complaintAtrs: [ComplaintAtr]) {
		self.complaintAtrs = complaintAtrs
	}
	
	func didFailLoadComplaintAtrs(with error: Error) {
		print(error)
	}
	
	func didLoad(_ authorities: [Authority]) {
		self.authorities = authorities
	}
	
	func didFailLoadAuthorities(with error: Error) {
		print(error)
	}
	
	func didLoad(_ cities: [City]) {
		self.cities = cities
	}
	
	func didFailLoadCities(with error: Error) {
		print(error)
	}
	
	func didLoad(_ complaintData: ComplaintData) {
		print("Complaint:", complaintData)
		self.complaintData = complaintData
	}
	
	func didFailLoadComplaintData(with error: Error) {
		print("Fail load complaint with error: ", error.localizedDescription)
	}
}
