//
//  ProfileAwardsEventsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class AwardsCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
	
	var didScrollToPage: (Int) -> Void = { _ in }
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offSet = scrollView.contentOffset.x
		let width = scrollView.frame.width
		let horizontalCenter = width / 2
		
		let currentPage = Int(offSet + horizontalCenter) / Int(width)
		didScrollToPage(currentPage)
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let height = (collectionView.frame.height - 10*3)/4
		return CGSize(width: collectionView.frame.width * 2/3, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return sectionInsets
	}
	
}


class ProfileAwardsEventsViewController: UIViewController {
	
	let awardsLabel = UILabel()
	let eventsLabel = UILabel()
	let tableView = ContentSizedTableView()
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
	
	var collectionDelegate = AwardsCollectionDelegate()
	
	var collectionDataSource: CollectionViewDataSource<AwardsCollectionViewCell.Props, AwardsCollectionViewCell>!
	var dataSource: UTableViewDataSource<EventCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		awardsLabel.text = l10n(.awards)
		eventsLabel.text = l10n(.eventsFeed)
		configureCollectionView()
		updateTableData()
		layout()
	}
	
	private func configureCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		collectionView.collectionViewLayout = flowLayout
		collectionView.isPagingEnabled = false
		collectionView.alwaysBounceHorizontal = true
		collectionView.showsHorizontalScrollIndicator = false
		
		collectionView.delegate = collectionDelegate

		collectionDataSource = CollectionViewDataSource(collectionView) { $1.props = $0 }
		
		let cellsProps = Array(
			repeating: AwardsCollectionViewCell.Props(heading: l10n(.greetingHeading1), imageName: "aged_people"),
			count: 9
		)
		collectionDataSource.cellsProps = cellsProps
		collectionView.dataSource = collectionDataSource
	}
	
	private func layout() {
		collectionView.backgroundColor = .white
		tableView.backgroundColor = .darkText
		awardsLabel.decorate(with: Style.systemFont(size: 18, weight: .semibold))
		eventsLabel.decorate(with: Style.systemFont(size: 18, weight: .semibold))
		tableView.separatorInset = UIEdgeInsets(all: 0)
		tableView.separatorStyle = .none
		
		view.addSubview(awardsLabel)
		view.addSubview(eventsLabel)
		let line = UIView()
		line.backgroundColor = UIColor(named: "UnselectedTabbarTintColor")?.withAlphaComponent(0.2)
		view.addSubview(line)
		view.addSubview(tableView)
		view.addSubview(collectionView)
		
		let spacing: CGFloat = 16

		awardsLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
		
		collectionView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: awardsLabel, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -0)
			.set(my: .height, to: 222)
		
		line.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: collectionView, plus: spacing)
			.pinEdgeToSupers(.leading, plus: 0)
			.pinEdgeToSupers(.trailing, plus: -0)
			.set(my: .height, to: 1)

		eventsLabel.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: line, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
		
		tableView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: eventsLabel, plus: spacing)
			.pinEdgeToSupers(.leading, plus: spacing)
			.pinEdgeToSupers(.trailing, plus: -spacing)
			.pinEdgeToSupers(.bottom, plus: -spacing)
	
	}
	
	fileprivate func updateTableData() {
		dataSource = UTableViewDataSource(tableView)
		dataSource.cellsProps = [
			EventCell.Props(
				date: "12 августа",
				text: "Арай Молдахметова прокомментировала ваш объект Суши-бар Saya Sushi"
			)
		]
		tableView.dataSource = dataSource
		tableView.reloadData()
	}
	
}

class EventCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		detailTextLabel?.numberOfLines = 0
		
		let tempFont = detailTextLabel?.font
		detailTextLabel?.font = textLabel?.font
		textLabel?.font = tempFont
		
		detailTextLabel?.textColor = textLabel?.textColor
		textLabel?.textColor = .gray
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.detailTextLabel?.frame.origin.x = 0
		self.textLabel?.frame.origin.x = 0
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.date
			detailTextLabel?.text = props.text
		}
	}
	
	struct Props {
		let date: String?
		var text: String?
	}
	
}
