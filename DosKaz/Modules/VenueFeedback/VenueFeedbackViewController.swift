//
//  VenueFeedbackViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/28/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class VenueFeedbackViewController: UIViewController {
	
	let titleLb = UILabel()
	let tableView = ContentSizedTableView()
	var dataSource: UTableViewDataSource<VenueFeedbackCell>!
	var reviews = [Review]()
	
	func initWith(with reviews: [Review]) {
		self.reviews = reviews
	}
	
	private func update(with reviews: [Review]) {
		var testReviews = reviews
		
		testReviews.append(Review(author: "Елена Малышева", text: "Была там на днях, очень понравилось. Без туалета, конечно, не очень удобно, но руки помыть можно без проблем. Персонал очень вежливый, помогали мне. Суши просто огонь и пицца прям что надо, рекомендую!", date: "10 июля, 15:32"))
		testReviews.append(Review(author: "Аружан Толеухан", text: "Что могу сказать — в нашем городе не так уж много заведений, где нам можно комфортно покушать и отдохнуть. Так что Сая суши даже с имеющимися недостатками можно смело записывать в избранное.", date: "24 июня, 22:01"))
		
		let cellsProps = testReviews.map { VenueFeedbackCell.Props(review: $0) }
		dataSource.cellsProps = cellsProps
		tableView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
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
		
		titleLb.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.top, plus: 16)
		
		tableView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLb, plus: 10)
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.bottom, plus: -16)
			.set(my: .height, .greaterThanOrEqual, to: 90)
		
		
		update(with: reviews)
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
			dateLb.text = review.date
			textLb.text = review.text
		}
	}
	
	struct Props {
		var review: Review
	}
	
}

