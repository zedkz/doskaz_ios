//
//  MapPresenter.swift
//  Map
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-23 16:55:07 +0000 lobster.kz. All rights reserved.
//
import SharedCodeFramework
import CoreLocation
		
class MapPresenter: MapModuleInput {
	
	weak var view: MapViewInput!
	var interactor: MapInteractorInput!
	var router: MapRouterInput!

}


// MARK: ViewController output protocol

protocol MapViewOutput {
	func viewIsReady()
}

extension MapPresenter: MapViewOutput {
	func viewIsReady() {
		view.setupInitialState()
		view.buildSearch(with: CommandWith<SearchResults> { [weak self] results in
			print("search started", results)
		})
		
		interactor.loadPointsOnMap()

		view.onSelectVenue = CommandWith<Int> {
			self.interactor.loadObject(with: $0)
		}
		
		view.onPressFilter = Command { [weak self] _ in
			guard let self = self else { return }
			self.router.presentFilter(with: self.view)
		}
	}

}


// MARK: Interactor output protocol

protocol MapInteractorOutput: class {
	func didLoad(_ points: [Point])
	func didFailLoadPoints(with error: Error)
	
	func didLoad(_ venue: DoskazVenue)
	func didFailLoadVenue(with error: Error)
}

extension MapPresenter: MapInteractorOutput {
	func didLoad(_ points: [Point]) {
		let venues = points.map { point in
			return Venue(
				id: point.id,
				icon: point.icon?.filter { !" ".contains($0) } ?? "",
				color: point.color.uiColor,
				locationName: String(point.id) ,
				coordinate: CLLocationCoordinate2D(
					latitude: point.coordinates[0],
					longitude: point.coordinates[1]
				)
			)
		}
		
		view.show(venues)
		
	}
	
	func didFailLoadPoints(with error: Error) {
		
	}
	
	func didLoad(_ venue: DoskazVenue) {
		view.showSheet(for: venue)
	}
	
	func didFailLoadVenue(with error: Error) {
		
	}
	
}

