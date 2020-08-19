//
//  MapViewController.swift
//  Map
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-23 16:55:07 +0000 lobster.kz. All rights reserved.
//

import UIKit
import MapKit
import SharedCodeFramework

// MARK: View input protocol

protocol MapViewInput where Self: UIViewController {
	func setupInitialState()
	func buildSearch(with command: CommandWith<SearchResults>)
	func closeSearch()
	func show(_ annotations: [MKAnnotation])
	func showSheet(for doskazVenue: DoskazVenue)
	func zoom(for doskazVenue: DoskazVenue)
	
	var onSelectVenue: CommandWith<Int> { get set }
	var onPressFilter: Command { get set }
	var onRegionChanged: CommandWith<MapRect> { get set }
	var onTouchPlus: Command { get set }
	var onTouchComplain: Command { get set }
}

extension MapViewController: MapViewInput {
	
	func closeSearch() {
		searchController.isActive = false
	}

	func setupInitialState() {
		configureMapViewLayout()
		configureMapView()
		configureNavigationView()
		addDrawerViewController()
		configureChromeButtons()
	}

	func show(_ annotations: [MKAnnotation]) {
		let forRemoval = mapView.annotations.filter { (annotation) -> Bool in
			return annotation.coordinate.latitude != selectedAnnotation?.coordinate.latitude &&
				annotation.coordinate.longitude != selectedAnnotation?.coordinate.longitude
		}
		oldAnnotations.append(contentsOf: forRemoval)
		mapView.addAnnotations(annotations)

	}
	
	func showSheet(for doskazVenue: DoskazVenue) {
		drawerVC.render(venue: doskazVenue)
	}
	
	func zoom(for doskazVenue: DoskazVenue) {
		let coordinate =  CLLocationCoordinate2D(
			latitude: doskazVenue.coordinates[0],
			longitude: doskazVenue.coordinates[1]
		)
		let coordinateRegion = MKCoordinateRegion(
			center: coordinate,
			span: MKCoordinateSpan(
				latitudeDelta: 0.0033840424988866857,
				longitudeDelta: 0.003996139719617986
			)
		)
		mapView.setRegion(coordinateRegion, animated: true)
		
		guard let id = doskazVenue.id else {
			return
		}
		
		if let selectedAnnotation = selectedAnnotation {
			mapView.removeAnnotation(selectedAnnotation)
		}
		
		let venue = Venue(
			id: id,
			icon: doskazVenue.icon,
			color: doskazVenue.color.uiColor,
			locationName: doskazVenue.title,
			coordinate: coordinate
		)
		venue.isLarge = true
		mapView.addAnnotation(venue)
		selectedAnnotation = venue
		
	}
}


class MapViewController: UIViewController, CLLocationManagerDelegate {
	
	var selectedAnnotation: Venue?
	
	var oldAnnotations = [MKAnnotation]() {
		didSet {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
				self.mapView.removeAnnotations(self.oldAnnotations)
			}
		}
	}

	// MARK: Properties
	var output: MapViewOutput!
	private var mapView: MKMapView!
	private let regionRadius: CLLocationDistance = 5000
	private var searchController: UISearchController!
	private let addButton = Button()
	private let addComplaint = Button()
	
	var onSelectVenue: CommandWith<Int> = .nop
	var onPressFilter: Command = .nop
	var onRegionChanged: CommandWith<MapRect> = .nop
	var onTouchPlus: Command = .nop
	var onTouchComplain: Command = .nop

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}
	
	let drawerVC = DrawerViewController()
		
	func addDrawerViewController() {
		drawerVC.delegate = self
		addChild(drawerVC)
		view.addSubview(drawerVC.drawerView)
		drawerVC.didMove(toParent: self)
		
		drawerVC.drawerView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
	}
	
	let locationManager = CLLocationManager()

	private func configureMapViewLayout() {
		let mapView = MKMapView()
		view.addSubview(mapView)
		mapView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		self.mapView = mapView
	}

	var isNotCenteredOnce: Bool = true
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		func center(on location: CLLocation) {
			if isNotCenteredOnce {
				centerMapOnLocation(location: location)
				isNotCenteredOnce = false
			}
		}
		
		if let userLocation = userLocation.location {
			#if DEBUG
				let baiterek = (lat: 52.288218, lon: 76.969872)
				let initialLocation = CLLocation(latitude: baiterek.lat, longitude: baiterek.lon)
				center(on: initialLocation)
			#else
				center(on: userLocation)
			#endif
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .notDetermined {
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	private func configureMapView() {
		locationManager.delegate = self
		mapView.showsUserLocation = true
		mapView.showsCompass = false
		mapView.showsBuildings = true
		mapView.delegate = self
		mapView.register(
			VenueView.self,
			forAnnotationViewWithReuseIdentifier: NSStringFromClass(Venue.self)
		)
		mapView.register(
			ClusterAnnotationView.self,
			forAnnotationViewWithReuseIdentifier: NSStringFromClass(ClusterAnnotation.self)
		)
		mapView.register(
			LargeVenueView.self,
			forAnnotationViewWithReuseIdentifier: NSStringFromClass(LargeVenueView.self)
		)
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard !annotation.isKind(of: MKUserLocation.self) else {
			return nil
		}
		
		var annotationView: MKAnnotationView?
		
		if let annotation = annotation as? Venue {
			if annotation.isLarge {
				let ri = NSStringFromClass(LargeVenueView.self)
				annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ri, for: annotation)
			} else {
				let reuseIdentifier = NSStringFromClass(Venue.self)
				annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
			}
		} else if let annotation = annotation as? ClusterAnnotation {
			let reuseIdentifier = NSStringFromClass(ClusterAnnotation.self)
			annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
		}

		return annotationView
	}
	
	private func configureNavigationView() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "filter")?.withRenderingMode(.alwaysOriginal),
			style: .plain,
			target: self,
			action: #selector(didPressFilter)
		)
	}
	
	@objc
	func didPressFilter() {
		onPressFilter.perform()
	}
	
	func buildSearch(with command: CommandWith<SearchResults>) {
		let resultsController = SearchResultsViewControllerModuleConfigurator().assembleModule()
		resultsController.output.initView(with: command)
		let searchController = UISearchController(searchResultsController: resultsController)
		searchController.searchResultsUpdater = resultsController
		searchController.hidesNavigationBarDuringPresentation = false
		
		definesPresentationContext = true
		navigationItem.titleView = searchController.searchBar
		self.searchController = searchController
		searchController.searchBar.customize()
	}
	
	private func configureChromeButtons() {
		addButton.setImage(UIImage(named: "add_object"), for: .normal)
		
		view.addSubview(addButton)
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.trailingAnchor.constraint(equalTo: view.safeLayoutGuide.trailingAnchor, constant: -10).isActive = true
		addButton.bottomAnchor.constraint(equalTo: drawerVC.drawerView.panningView.topAnchor, constant: -10).isActive = true
		addButton.didTouchUpInside = { [weak self] in
			self?.onTouchPlus.perform()
		}
		
		addComplaint.setImage(UIImage(named: "add_complaint"), for: .normal)

		view.addSubview(addComplaint)
		addComplaint.translatesAutoresizingMaskIntoConstraints = false
		addComplaint.trailingAnchor.constraint(equalTo: view.safeLayoutGuide.trailingAnchor, constant: -10).isActive = true
		addComplaint.bottomAnchor.constraint(equalTo: addButton.safeLayoutGuide.topAnchor, constant: -16).isActive = true
		addComplaint.didTouchUpInside = { [weak self] in
			self?.onTouchComplain.perform()
		}
		
		let zoomToUser = MKUserTrackingBarButtonItem(mapView: mapView)
		if let barView = zoomToUser.customView {
			let box = UIView()
			mapView.addSubview(box)
			box.addConstraintsProgrammatically
				.pinEdgeToSupersSafe(.top, plus: 8)
				.pinEdgeToSupersSafe(.trailing, plus: -8)
				.set(my: .width, to: 34)
				.set(my: .height, to: 38)
			box.addSubview(barView)
			barView.addConstraintsProgrammatically
				.pinToSuper()
		}
	}
	
	// MARK: - Helper methods
	
	private func centerMapOnLocation(location: CLLocation, animated: Bool = false) {
		let coordinateRegion = MKCoordinateRegion(
			center: location.coordinate,
			latitudinalMeters: regionRadius,
			longitudinalMeters: regionRadius
		)
		mapView.setRegion(coordinateRegion, animated: animated)
	}
	
	private func center(on annotation: MKAnnotation) {		
		var currentRegion = mapView.region
		currentRegion.center = annotation.coordinate
		mapView.setRegion(currentRegion, animated: true)
	}
	
}


// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if let location = view.annotation as? Venue {
			print(location.coordinate)
			mapView.deselectAnnotation(view.annotation, animated: false)
			center(on: location)
			onSelectVenue.perform(with: location.id)

			if let selectedAnnotation = selectedAnnotation {
				mapView.removeAnnotation(selectedAnnotation)
			}

			let venue = Venue(
				id: location.id,
				icon: location.icon ?? "",
				color: location.color,
				locationName: location.locationName,
				coordinate: location.coordinate
			)
			venue.isLarge = true
			mapView.addAnnotation(venue)
			selectedAnnotation = venue
		} else if let clusterAnnoation = view.annotation as? ClusterAnnotation {
		
			let latitudeDelta = mapView.region.span.latitudeDelta*0.4
			let longitudeDelta = mapView.region.span.longitudeDelta*0.4
			
			let coordinateRegion = MKCoordinateRegion(
				center: clusterAnnoation.coordinate,
				span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
			)
			
			mapView.setRegion(coordinateRegion, animated: true)
		}
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		print("Region has changed")
		onRegionChanged.perform(with: MapRect(zoomLevel: mapView.zoomLevel, edges: mapView.edges))
	}
	
	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
		views.forEach { view in
			view.alpha = 0
			UIView.animate(withDuration: 0.3) {
				view.alpha = 1.0
			}
		}
	}
	
}

extension MapViewController: DrawerViewDelegate {
	func drawerView(_ drawerView: DrawerView, didChangePosition position: DrawerPosition) {
		print("Position:", position.contentHeight)
		
		if let selectedAnnotation = selectedAnnotation, position.contentHeight < 5.0 {
			mapView.removeAnnotation(selectedAnnotation)
		}
		
		let time = evaluate(addButton.alpha == 1.0, ifTrue: 0.2, ifFalse: 0.5)
		UIView.animate(withDuration: time) {
			let alpha: CGFloat = evaluate(position.contentHeight > self.view.bounds.height/2, ifTrue: 0.0, ifFalse: 1.0)
			self.addButton.alpha = alpha
			self.addComplaint.alpha = alpha
		}
		
	}
	
	func drawerViewIsPanning(_ drawerView: DrawerView) {
		let y = drawerView.panningView.frame.origin.y
		UIView.animate(withDuration: 0.1) {
			let alpha: CGFloat = evaluate(y < self.view.bounds.height/3, ifTrue: 0.0, ifFalse: 1.0)
			self.addButton.alpha = alpha
			self.addComplaint.alpha = alpha
		}
	}
}
