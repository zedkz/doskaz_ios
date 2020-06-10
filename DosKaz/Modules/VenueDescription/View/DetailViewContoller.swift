//
//  DetailViewContoller.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/10/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class DetailViewContoller: UITableViewController {
	
	var venue: DoskazVenue!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = l10n(.detailInfo)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "x_in_form"), style: .done,
			target: self,
			action: #selector(close)
		)
		
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
	
}
