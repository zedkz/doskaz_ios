//
//  SearchResultsViewControllerViewController.swift
//  SearchResultsViewController
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-03-01 13:52:49 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework

// MARK: View input protocol

protocol SearchResultsViewControllerViewInput: class {
	func setupInitialState()
	func showResults(with results: [BasicCell.Props])
	var updateSearchResults: CommandWith<String> { get set }
}

extension SearchResultsViewControllerViewController: SearchResultsViewControllerViewInput {

	func setupInitialState() {
		view.backgroundColor = .white
		configureTableViewStyle()
		configureTableViewLayout()
		configureTableViewDataSource()
	}
	
	func showResults(with results: [BasicCell.Props]) {
		dataSource.cellsProps = results
		tableView.reloadData()
	}

}


class SearchResultsViewControllerViewController: UIViewController, UISearchResultsUpdating {
	
	// MARK: Properties
	var output: SearchResultsViewControllerViewOutput!
	
	private var tableView: UITableView!
	private var dataSource: TableViewDataSource<BasicCell.Props, BasicCell>!
	
	var updateSearchResults: CommandWith<String> = .nop

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		updateSearchResults.perform(with: text)
	}
	
	// MARK: Private methods
	
	private func configureTableViewStyle() {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.tableFooterView = UIView()
		self.tableView = tableView
	}
	
	private func configureTableViewLayout() {
		view.addSubview(tableView)
		tableView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
	}
	
	private func configureTableViewDataSource() {
		dataSource = TableViewDataSource(tableView){ (props: BasicCell.Props, cell: BasicCell) in
			cell.props = props
		}
		
		tableView.dataSource = dataSource
	}

}
