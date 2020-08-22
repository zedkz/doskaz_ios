//
//  BlogCommentsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

enum BlogComment {
	case new(Int)
	case replies(Int, Comment)
}

class BlogCommentsViewController: ProfileCommonViewController, UITableViewDelegate, UITextViewDelegate {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(blogComment: BlogComment, onPickComment: CommandWith<Comment>, isScrollEnabled: Bool = true) {
		self.blogComment = blogComment
		self.onPickComment = onPickComment
		super.init(nibName: nil, bundle: nil)
		self.tableView.isScrollEnabled = isScrollEnabled
	}
	
	var blogComment: BlogComment
	var dataSource: UTableViewDataSource<BlogCommentCell>!
	var onPickComment: CommandWith<Comment>

	let commentView = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 78))
	let placeHolderLabel = UILabel()

	func textViewDidChange(_ textView: UITextView) {
		placeHolderLabel.isHidden = !textView.text.isEmpty
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		renderAfterCommenting()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		navigationItem.backBarButtonItem = backItem
		
		tableView.showsVerticalScrollIndicator = false
		props = Props(title: l10n(.comments), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.reloadData()
		tableView.delegate = self
		 
		commentView.addRightButtonOnKeyboardWithText(l10n(.send), target: self, action: #selector(handleSend))
		commentView.layer.borderColor = UIColor(named: "TextFieldBorderColor")?.cgColor
		commentView.layer.borderWidth = 1
		commentView.layer.cornerRadius = 3
		commentView.font = .systemFont(ofSize: 14)
		commentView.keyboardDistanceFromTextField = 4
		commentView.delegate = self

		placeHolderLabel.decorate(with: Style.systemFont(size: 11), { (label) in
			label.textColor = .gray
		})
		commentView.addSubview(placeHolderLabel)
		placeHolderLabel.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(all:8))

		placeHolderLabel.text = l10n(.yourComments)
		placeHolderLabel.isHidden = !commentView.text.isEmpty
		
		if AppSettings.token != nil {
			tableView.tableFooterView = commentView
		}
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
		
		tableView.separatorStyle = .singleLine
		tableView.separatorInset = UIEdgeInsets(all: 0)
		onPickLeft = OnPick<Sort> { [weak self] _ in
			self?.renderComments()
		}
		
		renderComments()
	}
	
	var id: Int {
		switch blogComment {
		case .new(let id): return id
		case .replies(let id, _ ): return id
		}
	}
	
	var parentId: String? {
		switch blogComment {
		case .new: return nil
		case .replies(_, let comment): return comment.id
		}
	}
	
	@objc
	func handleSend() {
		commentView.resignFirstResponder()

		let comment = BlogCommentPost(
			text: commentView.text,
			parentId: parentId
		)
		
		APIPostBlogComments(onSuccess: { [weak self] (empty) in
			self?.renderAfterCommenting()
			self?.commentView.text = nil
		}, onFailure: { error in
			print(error)
		}, id: id,
			 comment: comment
		)
		.dispatch()
	}
	
	private func renderAfterCommenting() {
		
		APIBlogComments(onSuccess: { [weak self] (response) in
			guard let self = self else { return }
			
			switch self.blogComment {
			case .new:
				
				self.dataSource.cellsProps = response.items.map { comment in
					BlogCommentCell.Props(comment: comment, onReply: Command { [weak self] in
						self?.onPickComment.perform(with: comment)
					})
				}
				self.tableView.reloadData()
				
			case .replies(_, let parent):
				
				func search(comments: [Comment]) {
					for comment in comments {
						if parent.id == comment.id {
							
							//show replies
							self.dataSource.cellsProps = comment.replies
								.sorted(by: self.sort.sortingClosure)
								.map { comment in
									BlogCommentCell.Props(comment: comment, onReply: Command { [weak self] in
										self?.onPickComment.perform(with: comment)
									})
							}
							self.tableView.reloadData()
							
						} else {
							// search again
							search(comments: comment.replies)
						}
					}
				}
				
				search(comments: response.items)
				
			}
			
		}, onFailure: { error in
			print(error)
		},
			sortOrder: sort.value,
			id: id
		)
		.dispatch()
		
	}
	
	private func renderComments() {
		switch blogComment {
		case .new(let id):
			loadComments(id: id)
		case .replies(_, let parent):
			props = Props(title: l10n(.replies), isRightButtonHidden: true)
			dataSource.cellsProps = parent.replies
				.sorted(by: sort.sortingClosure)
				.map { comment in
					BlogCommentCell.Props(comment: comment, onReply: Command { [weak self] in
						self?.onPickComment.perform(with: comment)
					})
				}
			tableView.reloadData()
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let comment = dataSource.cellsProps[indexPath.row].comment
		onPickComment.perform(with: comment)
	}
	
	private func loadComments(id: Int) {
		APIBlogComments(onSuccess: { [weak self] (response) in
			self?.props = Props(title: "\(l10n(.comments)): \(response.count)", isRightButtonHidden: true)
			self?.dataSource.cellsProps = response.items.map { comment in
				BlogCommentCell.Props(comment: comment, onReply: Command { [weak self] in
					self?.onPickComment.perform(with: comment)
				})
			}
			self?.tableView.reloadData()
		}, onFailure: { error in
			print(error)
		},
			 sortOrder: sort.value,
			 id: id
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
		if AppSettings.token != nil {
			vStack.addArrangedSubview(replyButton)
		}
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

