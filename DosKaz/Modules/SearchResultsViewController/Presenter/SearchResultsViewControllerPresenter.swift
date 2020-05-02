//
//  SearchResultsViewControllerPresenter.swift
//  SearchResultsViewController
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-03-01 13:52:49 +0000 lobster.kz. All rights reserved.
//
import SharedCodeFramework
		
class SearchResultsViewControllerPresenter: SearchResultsViewControllerModuleInput {
	
	weak var view: SearchResultsViewControllerViewInput!
	var interactor: SearchResultsViewControllerInteractorInput!
	var router: SearchResultsViewControllerRouterInput!

	var didPressShowOnMap: CommandWith<SearchResults> = .nop
	var currentResults = SearchResults()
}


// MARK: ViewController output protocol

protocol SearchResultsViewControllerViewOutput {
	func viewIsReady()
	func initView(with command: CommandWith<SearchResults>)
}

extension SearchResultsViewControllerPresenter: SearchResultsViewControllerViewOutput {
	
	func initView(with command: CommandWith<SearchResults>) {
		self.didPressShowOnMap = command
	}
	
	func viewIsReady() {
		view.setupInitialState()
		view.updateSearchResults = CommandWith<String> { searchText in
			self.interactor.search(for: searchText, with: 9103)
		}
		view.didTouchUpInside = { [weak self] in
			guard let self = self else { return }
			self.didPressShowOnMap.perform(with: self.currentResults)
		}
	}

}


// MARK: Interactor output protocol

protocol SearchResultsViewControllerInteractorOutput: class {
	func didFind(_ results: SearchResults)
	func didFailSearch(with error: Error)
}

extension SearchResultsViewControllerPresenter: SearchResultsViewControllerInteractorOutput {
	func didFind(_ results: SearchResults) {
		let searchResultsToShow = results.map {
			BasicCell.Props(
				text: $0.title,
				icon: $0.icon?.filter { !" ".contains($0) } ?? "",
				rightIcon: "chevron_right_passive"
			)
		}
		view.showResults(with: searchResultsToShow)
		currentResults = results
	}
	
	func didFailSearch(with error: Error) {
		print("didFailSearch: ",error.localizedDescription)
	}
}

