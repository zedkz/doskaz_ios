//
//  MapInteractor.swift
//  Map
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-23 16:55:07 +0000 lobster.kz. All rights reserved.
//

protocol MapInteractorInput {
	func loadPointsOnMap()
	func loadObject(with id: Int)
}

// MARK: Implementation

class MapInteractor: MapInteractorInput {

	weak var output: MapInteractorOutput!
	
	func loadPointsOnMap() {
		
		let onSuccess = { [weak self] (mapObjects: MapObjects) -> Void in
			self?.output.didLoad(mapObjects.points)
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.output.didFailLoadPoints(with: error)
		}
		
		let request = APIObjectsMap(
			onSuccess: onSuccess,
			onFailure: onFailure,
			zoom: 14,
			box: [52.2523,76.8384,52.3332,77.1021]
		)
		
		request.dispatch()

	}
	
	func loadObject(with id: Int) {
		let onSuccess = { [weak self] (doskazVenue: DoskazVenue) in
			debugPrint(doskazVenue)
			self?.output.didLoad(doskazVenue)
		}
		
		let onFailure = { (error: Error) in
			debugPrint(error)
		}
		
		let r = APIGetObject(onSuccess: onSuccess, onFailure: onFailure, id: id)
		r.dispatch()

	}

}
		
