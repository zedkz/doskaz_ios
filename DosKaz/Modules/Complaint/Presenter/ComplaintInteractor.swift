//
//  ComplaintInteractor.swift
//  Complaint
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-21 07:01:46 +0000 lobster.kz. All rights reserved.
//

protocol ComplaintInteractorInput {
	func loadComplaintData()
	func loadCities()
	func loadAuthorities()
	func loadComplaintAtrs()
}

// MARK: Implementation

class ComplaintInteractor: ComplaintInteractorInput {

	weak var output: ComplaintInteractorOutput!
	
	func loadComplaintData() {
		if let complaintData = ComplaintDataStorage.shared.retrieveData() {
			output.didLoad(complaintData)
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
		let onSuccess = { [weak self] (complaintAtrs: [ComplaintAtr]) -> Void in
			self?.output.didLoad(complaintAtrs)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadComplaintAtrs(with: error)
		}
		
		APIComplaintAtrs(onSuccess: onSuccess, onFailure: onFailure).dispatch()
	}

}
		
