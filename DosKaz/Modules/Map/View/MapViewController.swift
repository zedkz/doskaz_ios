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
	func show(_ points: [Venue])
	func showSheet(for doskazVenue: DoskazVenue)
	
	var onSelectVenue: CommandWith<Int> { get set }
	var onPressFilter: Command { get set }
	var onRegionChanged: CommandWith<MapRect> { get set }
}

extension MapViewController: MapViewInput {

	func setupInitialState() {
		configureMapViewLayout()
		configureMapView()
		configureNavigationView()
		addDrawerViewController()
		configureChromeButtons()
	}

	func show(_ points: [Venue]) {
		oldAnnotations.append(contentsOf: mapView.annotations)
		mapView.addAnnotations(points)
	}
	
	func showSheet(for doskazVenue: DoskazVenue) {
		drawerVC.render(venue: doskazVenue)
	}
}


class MapViewController: UIViewController {
	
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
			.pinToSuper()
	}

	private func configureMapViewLayout() {
		let mapView = MKMapView()
		view.addSubview(mapView)
		mapView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		self.mapView = mapView
	}
	
	private func configureMapView() {
		// set initial location
		let baiterek = (lat: 52.288218, lon: 76.969872)
		let initialLocation = CLLocation(latitude: baiterek.lat, longitude: baiterek.lon)
		centerMapOnLocation(location: initialLocation)
		
		mapView.delegate = self
		mapView.register(VenueView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		
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
		
		addComplaint.setImage(UIImage(named: "add_complaint"), for: .normal)

		view.addSubview(addComplaint)
		addComplaint.translatesAutoresizingMaskIntoConstraints = false
		addComplaint.trailingAnchor.constraint(equalTo: view.safeLayoutGuide.trailingAnchor, constant: -10).isActive = true
		addComplaint.bottomAnchor.constraint(equalTo: addButton.safeLayoutGuide.topAnchor, constant: -16).isActive = true
	}
	
	// MARK: - Helper methods
	
	private func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(
			center: location.coordinate,
			latitudinalMeters: regionRadius,
			longitudinalMeters: regionRadius
		)
		mapView.setRegion(coordinateRegion, animated: true)
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
		let location = view.annotation as! Venue
		print(location.coordinate)
		mapView.deselectAnnotation(view.annotation, animated: false)
		center(on: location)
		onSelectVenue.perform(with: location.id)
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
