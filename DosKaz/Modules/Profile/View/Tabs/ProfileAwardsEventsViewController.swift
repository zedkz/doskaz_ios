//
//  ProfileAwardsEventsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit



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
		loadAwards()
	}
	
	private func loadAwards() {
		let onSuccess = { [weak self] (profileAwards: [ProfileAward]) -> Void in
			let cellsProps = profileAwards.map { award in
				AwardsCollectionViewCell.Props(heading: award.title, imageName: award.type.rawValue)
			}
			self?.collectionDataSource.cellsProps = cellsProps
			self?.collectionView.reloadData()
		}
		
		let onFailure = { (error: Error) -> Void in
			debugPrint(error)
		}
		
		APIProfileAwards(onSuccess: onSuccess, onFailure: onFailure)
			.dispatch()
		
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
