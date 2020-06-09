//
//  ProfileComplaintsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/20/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class ComplaintsPaginator: Paginator {
	
	var onLoad: CommandWith<ProfileComplaints> = .nop
	var onFail: CommandWith<Error> = .nop
	
	var sort: String?
	
	override func load(page: Int) {
		super.load(page: page)
		
		let onSuccess = { [weak self] (profileComplaints: ProfileComplaints) -> Void in
			self?.didSucced(totalPages: profileComplaints.pages)
			self?.onLoad.perform(with: profileComplaints)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.didFail()
			self?.onFail.perform(with: error)
		}
		
		APIProfileComplaints(
			onSuccess: onSuccess,
			onFailure: onFailure,
			page: page,
			sort: sort
		)
			.dispatch()
	}
	
}

class ProfileComplaintsViewController: ProfileCommonViewController, UITableViewDelegate {
	
	var dataSource: UTableViewDataSource<ComplaintCell>!
	
	let paginator = ComplaintsPaginator()
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		paginator.loadNext()
	}
	
	private func configurePaginator() {
		
		paginator.sort = sort.objectsRequestValue
		
		paginator.onLoad = CommandWith<ProfileComplaints> { [weak self] profileComplaints in
			let cellsProps: [ComplaintCell.Props] = profileComplaints.items.map { complaint in
				ComplaintCell.Props(
					title: complaint.title, text: complaint.type.description,
					subTitle: complaint.date.full
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
		props = Props(title: l10n(.myComplaints), isRightButtonHidden: true)
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.reloadData()
		tableView.allowsSelection = false
		tableView.delegate = self
		
		configurePaginator()
		
		onPickLeft = OnPick<Sort> {
			self.dataSource.cellsProps = []
			self.paginator.reset()
			self.paginator.sort = $0.objectsRequestValue
			self.paginator.loadNext()
		}
		
		paginator.loadNext()

	}
	
}

class ComplaintCell: UITableViewCell, Updatable {
	
	let titleLabel = UILabel()
	let button = Button(type: .system)
	let textL = UILabel()
	let detailLab = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textL.numberOfLines = 0
		detailLab.textColor = .gray
		detailLab.numberOfLines = 0
		detailLab.font = detailTextLabel?.font
		titleLabel.decorate(with: Style.systemFont(size: 14, weight: .semibold), { label in
			label.numberOfLines = 0
		})
		
		button.setTitle(" " + l10n(.downLoadComplaints), for: .normal)
		button.setImage(UIImage(named: "load_complaint"), for: .normal)
		button.titleLabel?.font = detailTextLabel?.font
		button.setTitleColor(detailTextLabel?.textColor, for: .normal)
		
		layoutCustomSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func layoutCustomSubviews() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(button)
		contentView.addSubview(textL)
		contentView.addSubview(detailLab)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 20)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
		
		textL.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 4)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
		
		detailLab.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: textL, plus: 8)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.bottom)
		
		button.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: textL, plus: 8)
			.pin(my: .leading, to: .trailing, of: detailLab)
			.pinEdgeToSupers(.trailing)
			
		
		detailLab.setContentHuggingPriority(.defaultLow, for: .horizontal)
		detailLab.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
	}
	
	var props: Props! {
		didSet {
			titleLabel.text = props.title
			textL.text = props.text
			detailLab.text = props.subTitle
		}
	}
	
	struct Props {
		let title: String
		let text: String?
		var subTitle: String?
	}
	
}
