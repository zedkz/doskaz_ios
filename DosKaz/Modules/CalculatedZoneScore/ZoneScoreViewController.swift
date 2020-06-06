//
//  ZoneScoreViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ZoneScoreViewController: UIViewController, UITableViewDelegate {
	
	var parameters: ZoneParameters!
	
	func initWith(parameters: ZoneParameters) {
		self.parameters = parameters
	}
	
	let tableView = ContentSizedTableView()
	var dataSource: UTableViewDataSource<ZoneScoreCell>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
		let gestRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		view.addGestureRecognizer(gestRecognizer)
		
		view.addSubview(tableView)
		tableView.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.leading, plus: 30)
			.pinEdgeToSupers(.trailing, plus: -30)
		
		tableView.layer.cornerRadius = 2
		
		let headerView = UIView()
		headerView.backgroundColor = UIColor(named:"FilterHeaderColor")
		headerView.frame.size.height = 50
		let headerLabel = UILabel()
		headerLabel.backgroundColor = .clear
		headerLabel.text = l10n(.zoneScore).uppercased()
		headerLabel.decorate(with: Style.systemFont(size: 13))

		headerView.addSubview(headerLabel)
		headerLabel.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = UIView()
		
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.delegate = self
		
		let fake = ZoneScore(
			movement: .notProvided,
			limb: .notProvided,
			vision: .notProvided,
			hearing: .notProvided,
			intellectual: .notProvided
		)
		update(with: fake)
		
		calculateZoneScore()
	}
	
	func update(with z: ZoneScore) {
		let cellsProps = [
			ZoneProps(title: l10n(.movementZoneScoreText), score: z.movement),
			ZoneProps(title: l10n(.limb), score: z.limb),
			ZoneProps(title: l10n(.vision), score: z.vision),
			ZoneProps(title: l10n(.hearing), score: z.hearing),
			ZoneProps(title: l10n(.intellectual), score: z.intellectual),
		]
		dataSource.cellsProps = cellsProps
		tableView.reloadData()
	}
	
	fileprivate func calculateZoneScore() {
		let onSuccess = { [weak self] (zoneScore: ZoneScore) -> Void in
			debugPrint(zoneScore)
			self?.update(with: zoneScore)
		}
		
		let onFailure = { (error: Error) -> Void in
			debugPrint(error)
		}
		
		guard let parameters = self.parameters else { return }
		
		APICalculateZoneScore(
			onSuccess: onSuccess,
			onFailure: onFailure,
			zoneParameters: parameters
		).dispatch()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	@objc
	func tap() {
		dismiss(animated: true, completion: nil)
	}
		
}

extension UIViewController {
	func showZoneScore(with parameters: ZoneParameters) {
		let vc = ZoneScoreViewController()
		vc.initWith(parameters: parameters)
		vc.modalTransitionStyle = .crossDissolve
		vc.modalPresentationStyle = .overCurrentContext
		self.present(vc, animated: true, completion: nil)
	}
}

class ZoneScoreCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.numberOfLines = 0
		textLabel?.decorate(with: Style.systemFont(size: 14))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

	var props: Props! {
		didSet {
			textLabel?.text = props.title
			let image = UIImage(named: props.icon)
			accessoryView = UIImageView(image: image)
		}
	}
	
	struct Props {
		let title: String
		var score: OverallScore
		
		var icon: String {
			switch score {
			case .fullAccessible:
				return "available_32"
			case .partialAccessible:
				return "partially_available_32"
			case .notAccessible:
				return "not_available_32"
			case .notProvided, .unKnown:
				return "not_provided"
			}
		}
	}

}

typealias ZoneProps = ZoneScoreCell.Props
