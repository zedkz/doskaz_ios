//
//  LocationPickerController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/25/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import MapKit

class LocationPickerController: UIViewController {
	
	let mapView = MKMapView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Выберите объект"
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: l10n(.close), style: .done,
			target: self,
			action: #selector(closePicker)
		)
		view.addSubview(mapView)
		mapView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
	}
	
	@objc func closePicker() {
		FilterStorage.shared.store(Filter.shared)
		dismiss(animated: true, completion: nil)
	}
	
}
