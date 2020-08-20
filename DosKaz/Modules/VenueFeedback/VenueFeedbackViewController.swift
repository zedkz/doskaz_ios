//
//  VenueFeedbackViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/28/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class VenueFeedbackViewController: UIViewController {
	
	let postReviewButton = UIButton(type: .system)
	let titleLb = UILabel()
	let tableView = ContentSizedTableView()
	var dataSource: UTableViewDataSource<VenueFeedbackCell>!
	var reviews = [Review]()
	
	func initWith(_ reviews: [Review]) {
		self.reviews = reviews
	}
	
	private func update(with reviews: [Review]) {
		let cellsProps = reviews.map { VenueFeedbackCell.Props(review: $0) }
		dataSource.cellsProps = cellsProps
		tableView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		postReviewButton.setTitle(l10n(.writeReview), for: .normal)
		postReviewButton.addTarget(self, action: #selector(addReview), for: .touchUpInside)
		
		titleLb.text = l10n(.reviews).uppercased()
		titleLb.decorate(with: Style.systemFont(size: 14, weight: .bold))
		
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.allowsSelection = false
		tableView.isUserInteractionEnabled = false
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		
		view.addSubview(titleLb)
		view.addSubview(tableView)
		view.addSubview(postReviewButton)
		
		titleLb.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.top, plus: 16)
		
		tableView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLb, plus: 10)
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.bottom, plus: -16)
			.set(my: .height, .greaterThanOrEqual, to: 90)
		
		postReviewButton.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pin(my: .firstBaseline, andOf: titleLb)
		
		update(with: reviews)
	}
	
	func initWith(objectId: Int, onClose: Command) {
		self.objectId = objectId
		self.onClose = onClose
	}
	
	var objectId: Int!
	
	var onClose: Command = .nop
	
	@objc func addReview() {
		let postReviewViewController = FeedbackViewController()
		postReviewViewController.initWith(objectId: objectId, onClose: onClose)
		let nav = UINavigationController(rootViewController: postReviewViewController)
		present(nav, animated: true, completion: nil)
	}
	
}



class VenueFeedbackCell: UITableViewCell, Updatable {
	
	let authorLb = UILabel()
	let dateLb = UILabel()
	let textLb = UILabel()
	
	var stack: UIStackView = {
		let s = UIStackView()
		s.axis = .vertical
		s.spacing = 8
		return s
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		
		authorLb.decorate(with: Style.systemFont(size: 14, weight: .semibold))
		dateLb.decorate(with: Style.systemFont(size: 12))
		dateLb.textColor = .gray
		textLb.numberOfLines = 0
		
		contentView.addSubview(stack)
		stack.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
		
		stack.addArrangedSubview(authorLb)
		stack.addArrangedSubview(dateLb)
		stack.addArrangedSubview(textLb)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var props: Props! {
		didSet {
			let review = props.review
			authorLb.text = review.author
			dateLb.text = review.createdAt.dayMonth
			textLb.text = review.text
		}
	}
	
	struct Props {
		var review: Review
	}
	
}

