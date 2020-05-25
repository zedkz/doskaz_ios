//
//  LocationPickerController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/25/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import MapKit
import SharedCodeFramework

typealias DKLocation = (text: String, numeric: [Double])

class LocationPickerController: UIViewController {
	
	let mapView = MKMapView()
	
	var onDismiss: CommandWith<DKLocation> = .nop
	
	private let regionRadius: CLLocationDistance = 5000
	
	private var pickedCoordinate: CLLocationCoordinate2D?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = l10n(.chooseObject)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: l10n(.close), style: .done,
			target: self,
			action: #selector(closePicker)
		)
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		mapView.addGestureRecognizer(tapGestureRecognizer)
		
		let pavlodar = (lat: 52.288218, lon: 76.969872)
		let initialLocation = CLLocation(latitude: pavlodar.lat, longitude: pavlodar.lon)
		centerMapOnLocation(location: initialLocation)
		
		view.addSubview(mapView)
		mapView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
	}
	
	@objc func closePicker() {
		dismiss(animated: true, completion: {
			
			
			if let pickedCoordinate = self.pickedCoordinate {
				let str = "\(pickedCoordinate.latitude), \(pickedCoordinate.longitude)"
				let arr = [
					(Double(pickedCoordinate.latitude) * 1000000).rounded() / 1000000,
					(Double(pickedCoordinate.longitude) * 1000000).rounded() / 1000000,
				]
				self.onDismiss.perform(with: (str,arr))
			}
			
		})
	}
	
	@objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
		let locationOfTOuch = gestureRecognizer.location(in: mapView)
		let coordinate = mapView.convert(locationOfTOuch, toCoordinateFrom: mapView)
		
		let pin: MKPointAnnotation = MKPointAnnotation()
		pin.coordinate = coordinate
		
		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotation(pin)
		
		pickedCoordinate = coordinate
	}
	
	
	private func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(
			center: location.coordinate,
			latitudinalMeters: regionRadius,
			longitudinalMeters: regionRadius
		)
		mapView.setRegion(coordinateRegion, animated: true)
	}

}
