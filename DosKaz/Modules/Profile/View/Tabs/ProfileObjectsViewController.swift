//
//  ProfileObjectsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/19/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class ObjectsPaginator: Paginator {
	
	var onLoad: CommandWith<ProfileObjects> = .nop
	var onFail: CommandWith<Error> = .nop
	
	var sort: String?
	
	var overallScore: OverallScore?

	override func load(page: Int) {
		super.load(page: page)
		
		let onSuccess = { [weak self] (profileObjects: ProfileObjects) -> Void in
			self?.didSucced(totalPages: profileObjects.pages)
			self?.onLoad.perform(with: profileObjects)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.didFail()
			self?.onFail.perform(with: error)
		}
		
		APIProfileObjects(
			onSuccess: onSuccess,
			onFailure: onFailure,
			page: page,
			sort: sort,
			overallScore: overallScore
		)
			.dispatch()
	}
	
}

class ProfileObjectsViewController: ProfileCommonViewController, UITableViewDelegate {
	
	var dataSource: UTableViewDataSource<ObjectCell>!
	
	let paginator = ObjectsPaginator()
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		paginator.loadNext()
	}
	
	private func configurePaginator() {
		paginator.overallScore = score
		paginator.sort = sort.objectsRequestValue
		
		paginator.onLoad = CommandWith<ProfileObjects> { [weak self] profileObjects in
			let cellsProps: [ObjectCell.Props] = profileObjects.items.map { object in
				return ObjectCell.Props(
					title: object.title,
					subTitle: object.date.dayMonthYear,
					cornerText: object.description,
					image: object.image,
					score: object.overallScore
				)
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
		props = Props(title: l10n(.myObjects), isRightButtonHidden: false)
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.allowsSelection = false
		
		configurePaginator()
		
		onPickLeft = OnPick<Sort> {
			self.dataSource.cellsProps = []
			self.paginator.reset()
			self.paginator.sort = $0.tasksRequestValue
			self.paginator.loadNext()
		}
		
		onPickRight = OnPick<OverallScore> {
			self.dataSource.cellsProps = []
			self.paginator.reset()
			self.paginator.overallScore = $0
			self.paginator.loadNext()
		}
		
		paginator.loadNext()
		
	}
	
}

class ObjectCell: UITableViewCell, Updatable {
	
	let cornerLabel = UILabel()
	let kimageView = UIImageView()
	let scoreImageView = UIImageView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		kimageView.contentMode = .scaleAspectFill
		kimageView.clipsToBounds = true
		kimageView.backgroundColor = .gray
		contentView.addSubview(kimageView)
		
		contentView.addSubview(scoreImageView)
		kimageView.addSubview(scoreImageView)
		scoreImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.set(my: .height, to: 20)
			.set(my: .width, to: 20)
		
		textLabel?.numberOfLines = 0
		detailTextLabel?.textColor = .gray
		
		cornerLabel.textAlignment = .right
		cornerLabel.textColor = .gray
		cornerLabel.font = detailTextLabel?.font
		contentView.addSubview(cornerLabel)
				
		kimageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.set(my: .height, to: 60)
			.set(my: .width, to: 60)
		
		textLabel?.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pin(my: .leading, to: .trailing, of: kimageView, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -8)
		
		detailTextLabel?.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: kimageView, plus: 10)
			.set(my: .top, .greaterThanOrEqual, to: .bottom, of: textLabel!, plus: 4)
			.set(my: .bottom, .lessThanOrEqual, to: .bottom, of: contentView, plus: -4)

		let constraint = detailTextLabel?.bottomAnchor.constraint(equalTo: kimageView.bottomAnchor)
		constraint?.priority = .defaultLow
		constraint?.isActive = true
		
		cornerLabel.addConstraintsProgrammatically
			.pin(my: .top, andOf: detailTextLabel!)
			.pin(my: .bottom, andOf: detailTextLabel!)
			.pin(my: .leading, to: .trailing, of: detailTextLabel!)
			.pin(my: .trailing, andOf: textLabel!)

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			detailTextLabel?.text = props.subTitle
			if let imageURL = props.image {
				let url = URL(string: Constants.mainURL + imageURL)
				kimageView.kf.indicatorType = .activity
				kimageView.kf.setImage(
					with: url,
					options: [
						.scaleFactor(UIScreen.main.scale),
						.transition(.fade(1)),
						.cacheOriginalImage
				])
			}
			cornerLabel.attributedText = props.cornerText
			scoreImageView.image = UIImage(named: props.icon)
		}
	}
	
	struct Props {
		let title: String
		var subTitle: String?
		var cornerText: NSAttributedString?
		var image: String?
		var score: OverallScore
		
		var icon: String {
			switch score {
			case .fullAccessible:
				return "available_32"
			case .partialAccessible:
				return "partially_available_32"
			case .notAccessible:
				return "not_available_32"
			case .notProvided:
				return "partially_available_32"
			case .unKnown:
				return "partially_available_32"
			}
		}
	}
	
}
