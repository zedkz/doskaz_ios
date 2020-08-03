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

class LocationPickerController: UIViewController, CLLocationManagerDelegate {
	
	let mapView = MKMapView()
	
	let locationManager = CLLocationManager()
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		print("Location:", location)
		
		let pin: MKPointAnnotation = MKPointAnnotation()
		pin.coordinate = location.coordinate
		
		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotation(pin)
		
		pickedCoordinate = location.coordinate
		loadAddress(for: "\(location.coordinate.longitude), \(location.coordinate.latitude)")
		manager.stopUpdatingLocation()
		centerMapOnLocation(location: location)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("One time location request failed", error.localizedDescription)
		let astana = (lat: 51.128286, lon: 71.430514)
		let initialLocation = CLLocation(latitude: astana.lat, longitude: astana.lon)
		centerMapOnLocation(location: initialLocation)
	}
	
	var onDismiss: CommandWith<DKLocation> = .nop
	
	private let regionRadius: CLLocationDistance = 5000
	
	private var pickedCoordinate: CLLocationCoordinate2D?
	
	private var pickedAddress: String?
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .notDetermined {
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.startUpdatingLocation()
		
		view.backgroundColor = .white
		navigationItem.title = l10n(.chooseObject)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: l10n(.close), style: .done,
			target: self,
			action: #selector(closePicker)
		)
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		mapView.addGestureRecognizer(tapGestureRecognizer)
		
		view.addSubview(mapView)
		mapView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
	}
	
	@objc func closePicker() {
		dismiss(animated: true, completion: {
			
			if let pickedCoordinate = self.pickedCoordinate {
				let str = self.pickedAddress ?? ""
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
		loadAddress(for: "\(coordinate.longitude), \(coordinate.latitude)")
	}
	
	private func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(
			center: location.coordinate,
			latitudinalMeters: regionRadius,
			longitudinalMeters: regionRadius
		)
		mapView.setRegion(coordinateRegion, animated: true)
	}
	
	func loadAddress(for geocode: String) {
		let onSuccess = { [weak self] (json: GeoDataResponse) -> Void in
			self?.pickedAddress = json.response.geoObjectCollection.featureMember.first?.geoObject.name
		}
		
		let onFailure = { (error: Error) -> Void in
			debugPrint(error)
		}
		
		Geocoder(onSuccess: onSuccess, onFailure: onFailure, geocode: geocode).dispatch()
	}

}
