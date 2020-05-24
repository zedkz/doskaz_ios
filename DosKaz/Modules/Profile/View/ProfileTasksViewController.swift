//
//  ProfileTasksViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/19/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class Paginator {
	var totalPages = 1
	var currentPage = 0
	var isFetchInProgress = false
	
	func loadNext() {
		let nextPage = currentPage + 1
		if nextPage <= totalPages, !isFetchInProgress {
			isFetchInProgress = true
			load(page: nextPage)
		}
	}
	
	func didSucced(totalPages: Int) {
		self.totalPages = totalPages
		currentPage += 1
		isFetchInProgress = false
	}
	
	func didFail() {
		isFetchInProgress = false
	}
	
	func load(page: Int) {
		
	}

}

class TasksPaginator: Paginator {
	
	var onLoad: CommandWith<ProfileTasks> = .nop
	var onFail: CommandWith<Error> = .nop
	
	override func load(page: Int) {
		super.load(page: page)
		let sort = "createdAt desc"
		let onSuccess = { [weak self] (profileTasks: ProfileTasks) -> Void in
			self?.didSucced(totalPages: profileTasks.pages)
			self?.onLoad.perform(with: profileTasks)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.didFail()
			self?.onFail.perform(with: error)
		}
		
		APIProfileTasks(onSuccess: onSuccess, onFailure: onFailure, page: page, sort: sort).dispatch()
	}
	
}

class ProfileTasksViewController: ProfileCommonViewController, UITableViewDelegate {
	
	var dataSource: UTableViewDataSource<TaskCell>!
	let paginator = TasksPaginator()
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		paginator.loadNext()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.isUserInteractionEnabled = false
		props = Props(title: l10n(.myTasks), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		
		paginator.onLoad = CommandWith<ProfileTasks> { tasks in
			let cellsProps:[TaskCell.Props] = tasks.items.map { (task: ProfileTask) in
				
				var date: String
				if let completedAt = task.completedAt {
					date = completedAt
				} else {
					date = task.createdAt ?? ""
				}
				
				return TaskCell.Props(
					title: task.title ?? "–",
					subTitle: "\(date)     \(task.points) \(l10n(.points)) ",
					image: UIImage(named: "aged_people"))
			}
			
			self.dataSource.cellsProps.append(contentsOf: cellsProps)
			self.tableView.reloadData()
		}
		
		paginator.onFail = CommandWith<Error> { error in
			print(error)
		}
		
	}

}

class TaskCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.textColor = .gray
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.imageView?.frame.origin.x = 0
		self.detailTextLabel?.frame.origin.x = imageView!.frame.maxX + 12
		self.textLabel?.frame.origin.x = imageView!.frame.maxX + 12
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			detailTextLabel?.text = props.subTitle
			imageView?.image = props.image
		}
	}
	
	struct Props {
		let title: String
		var subTitle: String?
		var image: UIImage?
	}
	
}
