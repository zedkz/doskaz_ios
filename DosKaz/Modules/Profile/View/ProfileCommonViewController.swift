//
//  ProfileTasksViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/19/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

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

	
	@objc
	func handleLeft() {
		pick(
			with: OnPick<Sort> { self.sort = $0 },
			currentValue: sort,
			choices: Sort.allCases
		)
	}
	
	
	@objc
	func handleRight() {
		pick(
			with: OnPick<OverallScore> { self.score = $0 },
			currentValue: score,
			choices: OverallScore.allCases
		)
	}
	
	private func layoutAndStyle() {
		titleLabel.decorate(with: Style.systemFont(size: 18, weight: .semibold))
		
		let spacing: CGFloat = 16
		
		view.addSubview(titleLabel)
		view.addSubview(reverseButtonLeft)
		view.addSubview(reverseButtonRight)
		view.addSubview(tableView)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
		reverseButtonLeft.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
		reverseButtonRight.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: spacing)
			.pin(my: .leading, to: .trailing, of: reverseButtonLeft, plus: spacing)
		tableView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: reverseButtonRight, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
			.pinEdgeToSupers(.bottom, plus: -spacing)
		
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
