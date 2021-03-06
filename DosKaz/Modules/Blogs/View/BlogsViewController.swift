//
//  BlogsViewController.swift
//  Blogs
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-14 17:21:04 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework

// MARK: View input protocol

protocol BlogsViewInput where Self: UIViewController {
	func setupInitialState()
	func updateTable(with cellsProps: [BlogCell.Props])
	var onSearchFieldEdit: CommandWith<String> { get set }
	var onSelect: CommandWith<Item> { get set }
	var onTouchFilter: Command { get set }
	var onSelectCategory: CommandWith<BlogCategory> { get set }
	var onScrollToBottom: Command { get set }
	func showActionSheet(with blogCategories: [BlogCategory])
}

extension BlogsViewController: BlogsViewInput {

	func setupInitialState() {
		view.backgroundColor = .white
		configureNavigationView()
		buildSearch()
		configureTable()
	}
	
	func updateTable(with cellsProps: [BlogCell.Props]) {
		dataSource.cellsProps = cellsProps
		tableView.reloadData()
	}
	
	func showActionSheet(with blogCategories: [BlogCategory]) {
		var actions = blogCategories.map { category in
			Action(title: category.title, handler: { [weak self] in
				self?.onSelectCategory.perform(with: category)
			})
		}
		
		let cancelAction = Action(title: l10n(.cancel), style: .cancel)
		actions.append(cancelAction)
		
		let sheet = GenericAlertPresenter(
			title: l10n(.categories),
			style: .actionSheet,
			actions: actions
		)
		sheet.present(in: self)
	}

}

class BlogsViewController: TableViewController, UITableViewDelegate {

	var output: BlogsViewOutput!
	var dataSource: UTableViewDataSource<BlogCell>!
	var onSearchFieldEdit: CommandWith<String> = .nop
	var onSelect: CommandWith<Item> = .nop
	var onTouchFilter: Command = .nop
	var onSelectCategory: CommandWith<BlogCategory> = .nop
	var onScrollToBottom: Command = .nop
	
	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}
	
	private func configureTable() {
		dataSource = UTableViewDataSource<BlogCell>(tableView)
		tableView.dataSource = dataSource
		tableView.delegate = self
		tableView.tableFooterView = UIView()
		tableView.separatorInset = UIEdgeInsets(all: 0)
		tableView.keyboardDismissMode = .interactive
	}
	
	private func configureNavigationView() {
		navigationItem.title = l10n(.blog)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "filter")?.withRenderingMode(.alwaysOriginal),
			style: .plain,
			target: self,
			action: #selector(didPressFilter)
		)
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
	}
	
	@objc
	func didPressFilter() {
		onTouchFilter.perform()
	}
	
	private func buildSearch() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = true
		searchController.obscuresBackgroundDuringPresentation = false
		definesPresentationContext = true
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if let item = dataSource.cellsProps[indexPath.row].item {
			onSelect.perform(with: item)
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset
		let bounds = scrollView.bounds
		let contentSize = scrollView.contentSize
		
		let inset = scrollView.contentInset
		let y = offset.y + bounds.size.height - inset.bottom
		
		let reload_distance:CGFloat = -150.0
		guard offset.y > 0 else { return }
		if y > (contentSize.height + reload_distance) {
			onScrollToBottom.perform()
		}
	}

}

extension BlogsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		onSearchFieldEdit.perform(with: text)
	}

}
