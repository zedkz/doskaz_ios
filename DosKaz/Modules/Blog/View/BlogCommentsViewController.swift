//
//  BlogCommentsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit


class BlogCommentsViewController: ProfileCommonViewController, UITableViewDelegate {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(blogId: Int) {
		self.blogId = blogId
		super.init(nibName: nil, bundle: nil)
	}
	
	var blogId: Int
	var dataSource: UTableViewDataSource<CommentCell>!
		
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.comments), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.reloadData()
		tableView.delegate = self
		tableView.tableFooterView = UIView()
		
		onPickLeft = OnPick<Sort> { _ in
			self.dataSource.cellsProps = []
		}
		
		loadComments()
	}
	
	private func loadComments() {
		APIBlogComments(onSuccess: { [weak self] (response) in
			self?.props = Props(title: "\(l10n(.comments)): \(response.count)", isRightButtonHidden: true)
			
		}, onFailure: { error in
			print(error)
		},
			 sortOrder: sort.value,
			 id: blogId
		)
			.dispatch()
	}

	
}

