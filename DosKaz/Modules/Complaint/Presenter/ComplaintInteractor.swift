//
//  ComplaintInteractor.swift
//  Complaint
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-21 07:01:46 +0000 lobster.kz. All rights reserved.
//

import Foundation

protocol ComplaintInteractorInput {
	func loadComplaintData()
	func loadCities()
	func loadAuthorities()
	func loadComplaintAtrs()
	func submitComplaint(with data: ComplaintData)
	func uploadImage(_ data: Data)
}

// MARK: Implementation

class ComplaintInteractor: ComplaintInteractorInput {

	weak var output: ComplaintInteractorOutput!
	
	func loadComplaintData() {
		if let complaintData = ComplaintDataStorage.shared.retrieveData() {
			output.didLoad(complaintData)
			return
		}
		
		let onSuccess = { [weak self] (complaintData: ComplaintData) -> Void in
			self?.output.didLoad(complaintData)
			ComplaintDataStorage.shared.store(complaintData)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadComplaintData(with: error)
		}
		
		APIComplaintData(onSuccess: onSuccess, onFailure: onFailure).dispatch()
	}
	
	func loadCities() {
		if let stored = CitiesStorage.shared.retrieveData() {
			output.didLoad(stored)
			return
		}
		
		let onSuccess = { [weak self] (cities: [City]) -> Void in
			self?.output.didLoad(cities)
			CitiesStorage.shared.store(cities)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadCities(with: error)
		}
		
		APICities(onSuccess: onSuccess, onFailure: onFailure).dispatch()
	}
	
	func loadAuthorities() {
		if let stored = AuthoritiesStorage.shared.retrieveData() {
			output.didLoad(stored)
			return
		}
		
		let onSuccess = { [weak self] (authorities: [Authority]) -> Void in
			self?.output.didLoad(authorities)
			AuthoritiesStorage.shared.store(authorities)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadAuthorities(with: error)
		}
		
		APIAuthorities(onSuccess: onSuccess, onFailure: onFailure).dispatch()
	}

	func loadComplaintAtrs() {
		if let stored = ComplaintsAtrsStorage.shared.retrieveData() {
			self.output.didLoad(stored)
			return
		}
		
		let onSuccess = { [weak self] (complaintAtrs: [ComplaintAtr]) -> Void in
			self?.output.didLoad(complaintAtrs)
			ComplaintsAtrsStorage.shared.store(complaintAtrs)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadComplaintAtrs(with: error)
		}
		
		APIComplaintAtrs(onSuccess: onSuccess, onFailure: onFailure).dispatch()
	}
	
	func submitComplaint(with data: ComplaintData) {
		let onSuccess = { [weak self] (empty: Empty) -> Void in
			self?.output.didSucceedSubmitForm()
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailSubmitForm(with: error)
		}
		
		APIPostComplaint(onSuccess: onSuccess, onFailure: onFailure, complaintData: data).dispatch()
		
	}
	
	func uploadImage(_ data: Data) {
		let onSuccess = { [weak self] (uploadResponse: UploadResponse) -> Void in
			self?.output.didLoadImage(with: uploadResponse)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadImage(with: error)
		}
		
		APIUpload(onSuccess: onSuccess, onFailure: onFailure, image: data).dispatch()
	}

}
		
