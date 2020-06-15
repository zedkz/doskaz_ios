//
//  BlogCommentsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class BlogCommentsViewController: ProfileCommonViewController, UITableViewDelegate {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(blogId: Int) {
		self.blogId = blogId
		super.init(nibName: nil, bundle: nil)
	}
	
	var blogId: Int
	var dataSource: UTableViewDataSource<BlogCommentCell>!
		
	override func viewDidLoad() {
		super.viewDidLoad()
		props = Props(title: l10n(.comments), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.reloadData()
		tableView.delegate = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .singleLine
		tableView.separatorInset = UIEdgeInsets(all: 0)
		onPickLeft = OnPick<Sort> { [weak self] _ in
			self?.loadComments()
		}
		
		loadComments()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
	}
	
	private func loadComments() {
		APIBlogComments(onSuccess: { [weak self] (response) in
			self?.props = Props(title: "\(l10n(.comments)): \(response.count)", isRightButtonHidden: true)
			self?.dataSource.cellsProps = response.items.map { comment in
				BlogCommentCell.Props(comment: comment, onReply: Command {
					
				})
			}
			self?.tableView.reloadData()
		}, onFailure: { error in
			print(error)
		},
			 sortOrder: sort.value,
			 id: blogId
		)
			.dispatch()
	}

	
}

class BlogCommentCell: UITableViewCell, Updatable {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let topStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 8
		stack.alignment = .top
		return stack
	}()
	
	let vStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 8
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 8)
		return stack
	}()
	
	let avatar = UIImageView()
	let nameLabel = UILabel()
	let dateLabel = UILabel()
	
	let textLab = UILabel()
	let replyButton = UIButton(type: .system)
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		nameLabel.decorate(with: Style.systemFont(size: 14, weight: .semibold), { label in
			label.numberOfLines = 0
		})
		let gray = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 1)
		dateLabel.decorate(with: Style.systemFont(size: 12), { label in
			label.textColor = gray
		})
		textLab.decorate(with: Style.systemFont(size: 14), { label in
			label.numberOfLines = 0
		})
		replyButton.decorate(with: Style.systemFont(size: 10), { button in
			button.setTitleColor(gray, for: .normal)
		})
		selectionStyle = .none
		
		replyButton.setTitle(l10n(.reply), for: .normal)
		replyButton.contentHorizontalAlignment = .left
		replyButton.addTarget(self, action: #selector(reply), for: .touchUpInside)

		contentView.addSubview(vStack)
		vStack.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.bottom)
			.pinEdgeToSupers(.trailing)
		
		topStack.addArrangedSubview(avatar)
		topStack.addArrangedSubview(nameLabel)
		topStack.addArrangedSubview(dateLabel)
		avatar.addConstraintsProgrammatically
			.set(my: .height, to: 24)
			.set(my: .width, to: 24)
		nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
		dateLabel.setContentHuggingPriority(.required, for: .horizontal)
		
		vStack.addArrangedSubview(topStack)
		vStack.addArrangedSubview(textLab)
		vStack.addArrangedSubview(replyButton)
		
	}
	
	@objc func reply() {
		props.onReply.perform()
	}
	
	var props: Props! {
		didSet {
			avatar.image = UIImage(named: "comment_avatar")
			nameLabel.text = props.comment.userName.isEmpty ? "–" : props.comment.userName
			dateLabel.text = props.comment.createdAt.dayMonthTime
			textLab.text = props.comment.text
			
		}
	}
	
	struct Props {
		let comment: Comment
		var onReply: Command = .nop
	}
	
}

