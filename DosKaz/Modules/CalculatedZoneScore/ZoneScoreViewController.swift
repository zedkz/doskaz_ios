//
//  ZoneScoreViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ZoneScoreViewController: UIViewController {
	
	let tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		tableView.addConstraintsProgrammatically
			.pinToSuper()
		
		let headerView = UIView()
		headerView.frame.size.height = 50
		let headerLabel = UILabel()
		headerLabel.text = l10n(.zoneScore)
		headerView.addSubview(headerLabel)
		headerLabel.addConstraintsProgrammatically
			.pinToSuper()
		tableView.tableHeaderView = headerView
	}
	
	fileprivate func calculateZoneScore() {
		let onSuccess = { (zoneScore: ZoneScore) -> Void in
			debugPrint(zoneScore)
		}
		
		let onFailure = { (error: Error) -> Void in
			debugPrint(error)
		}
		
		let parameters = ZoneParameters(type: "parking_small", attributes: [
			"attribute1": FormValue.yes
		])
		
		APICalculateZoneScore(
			onSuccess: onSuccess,
			onFailure: onFailure,
			zoneParameters: parameters
		).dispatch()
	}
		
}
