//
//  ZoneScoreViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ZoneScoreViewController: UIViewController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
