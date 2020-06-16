//
//  ProfileTasksViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/19/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import Foundation

class ProfileCommonViewController: UIViewController {
	
	struct Props {
		var title: String
		var isRightButtonHidden: Bool
	}
	
	var props: Props! {
		didSet {
			titleLabel.text = props.title
			reverseButtonRight.isHidden = props.isRightButtonHidden
		}
	}
	
	let titleLabel = UILabel()
	let reverseButtonLeft = ReverseButton(type: .system)
	let reverseButtonRight = ReverseButton(type: .system)
	let tableView = ContentSizedTableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.text = "-"
		reverseButtonLeft.setTitle(sort.description, for: .normal)
		reverseButtonLeft.setImage(UIImage(named: "chevron_down"), for: .normal)
		reverseButtonRight.setTitle(score.description, for: .normal)
		reverseButtonRight.setImage(UIImage(named: "chevron_down"), for: .normal)
		
		layoutAndStyle()
		reverseButtonLeft.addTarget(self, action: #selector(handleLeft), for: .touchUpInside)
		reverseButtonRight.addTarget(self, action: #selector(handleRight), for: .touchUpInside)
	}
	
	var sort = Sort.ascending {
		didSet {
			reverseButtonLeft.setTitle(sort.description, for: .normal)
		}
	}

	var score = OverallScore.fullAccessible {
		didSet {
			reverseButtonRight.setTitle(score.description, for: .normal)
		}
	}
	
	var onPickLeft: OnPick<Sort> = .nop

	var onPickRight: OnPick<OverallScore> = .nop
	
	@objc
	func handleLeft() {
		pick(
			with: OnPick<Sort> {
				self.sort = $0
				self.onPickLeft.perform(with: $0)
			},
			currentValue: sort,
			choices: Sort.allCases
		)
	}
	
	
	@objc
	func handleRight() {
		pick(
			with: OnPick<OverallScore> {
				self.score = $0
				self.onPickRight.perform(with: $0)
			},
			currentValue: score,
			choices: OverallScore.allCases
		)
	}
	
	private func layoutAndStyle() {
		titleLabel.decorate(with: Style.systemFont(size: 18, weight: .semibold))
		tableView.separatorInset = UIEdgeInsets(all: 0)
		tableView.separatorStyle = .none
		
		let spacing: CGFloat = 16
		
		view.addSubview(titleLabel)
		view.addSubview(reverseButtonLeft)
		view.addSubview(reverseButtonRight)
		view.addSubview(tableView)
		
		titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
		reverseButtonLeft.setContentHuggingPriority(.defaultHigh, for: .vertical)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.top, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
		reverseButtonLeft.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
		reverseButtonRight.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: spacing)
			.pin(my: .leading, to: .trailing, of: reverseButtonLeft, plus: spacing)
		tableView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: reverseButtonLeft, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
			.pinEdgeToSupers(.bottom, plus: -spacing)
		
		let footer = UIView()
		footer.frame.size.height = 44
		
		let image = UIImage(named: "chevron_up")
		let imView = UIImageView(image: image)
		footer.addSubview(imView)
		imView.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.horizontalCenter)
		
		tableView.tableFooterView = footer
		
	}
	
}

enum Sort: Int, CustomStringConvertible, CaseIterable {
	case ascending
	case descending
	
	var description: String {
		switch self {
		case .ascending:
			return l10n(.oldFirst)
		case .descending:
			return l10n(.newFirst)
		}
	}
}

extension Sort {
	var tasksRequestValue: String {
		switch self {
		case .ascending:
			return "createdAt asc"
		case .descending:
			return "createdAt desc"
		}
	}
	
	var objectsRequestValue: String {
		switch self {
		case .ascending:
			return "date asc"
		case .descending:
			return "date desc"
		}
	}
	
	var value: String {
		switch self {
		case .ascending:
			return "asc"
		case .descending:
			return "desc"
		}
	}
	
	var sortingClosure: (Comment, Comment) -> Bool {
		switch self {
		case .ascending:
			return { $0.createdAt < $1.createdAt }
		case .descending:
			return { $0.createdAt > $1.createdAt }
		}
	}

}
