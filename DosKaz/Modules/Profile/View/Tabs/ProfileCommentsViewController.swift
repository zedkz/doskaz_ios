//
//  ProfileCommentsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class CommentsPaginator: Paginator {
	
	var onLoad: CommandWith<ProfileComments> = .nop
	var onFail: CommandWith<Error> = .nop
	
	var sort: String?
	
	override func load(page: Int) {
		super.load(page: page)
		
		let onSuccess = { [weak self] (profileComments: ProfileComments) -> Void in
			self?.didSucced(totalPages: profileComments.pages)
			self?.onLoad.perform(with: profileComments)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.didFail()
			self?.onFail.perform(with: error)
		}
		
		APIProfileComments(
			onSuccess: onSuccess,
			onFailure: onFailure,
			page: page,
			sort: sort
		)
			.dispatch()
	}
	
}

class ProfileCommentsViewController: ProfileCommonViewController, UITableViewDelegate {
	
	var dataSource: UTableViewDataSource<CommentCell>!
	
	let paginator = CommentsPaginator()
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		paginator.loadNext()
	}
	
	private func configurePaginator() {
		
		paginator.sort = sort.objectsRequestValue
		
		paginator.onLoad = CommandWith<ProfileComments> { [weak self] profileComments in
			let cellsProps: [CommentCell.Props] = profileComments.items.map { comment in
				CommentCell.Props(title: comment.text, subTitle: comment.title)
			}

			self?.dataSource.cellsProps.append(contentsOf: cellsProps)
			self?.tableView.reloadData()
		}
		
		paginator.onFail = CommandWith<Error> { error in
			print(error)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.myComments), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		dataSource.cellsProps = [
			CommentCell.Props(
				title: "Хотелось бы добавить, что входная группа сделана не очень удобно для людей, передвигающихся на колясках. Угол наклона пандуса очень большой, подниматься без посторонней помощи сложно. А зимой там ещё хуже будет.",
				subTitle: "Вчера в 18:01 к объекту Стоматологическая клиника Vitadent"
			)
		]
		tableView.dataSource = dataSource
		tableView.reloadData()
		tableView.delegate = self
		configurePaginator()
	}
	
}

class CommentCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.textColor = .gray
		detailTextLabel?.numberOfLines = 0
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		detailTextLabel?.frame.origin.x = 0
		textLabel?.frame.origin.x = 0
		textLabel?.frame.size.width = contentView.frame.width
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			detailTextLabel?.text = props.subTitle
		}
	}
	
	struct Props {
		let title: String
		var subTitle: String?
	}
	
}
