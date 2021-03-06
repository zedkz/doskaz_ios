//
//  SearchResultsViewControllerInteractor.swift
//  SearchResultsViewController
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-03-01 13:52:49 +0000 lobster.kz. All rights reserved.
//

protocol SearchResultsViewControllerInteractorInput {
	func search(for query: String, with cityID: Int)
}

// MARK: Implementation

class SearchResultsViewControllerInteractor: SearchResultsViewControllerInteractorInput {

	weak var output: SearchResultsViewControllerInteractorOutput!
	
	func search(for query: String, with cityID: Int) {
		let onSuccess = { [weak self] (results: SearchResults) -> Void in
			self?.output.didFind(results)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailSearch(with: error)
		}
		
		APISearch(
			onSuccess: onSuccess,
			onFailure: onFailure,
			cityId: cityID,
			query: query
		).dispatch()
	}

}
