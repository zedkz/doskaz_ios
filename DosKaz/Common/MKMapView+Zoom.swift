//
//  MKMapView+Zoom.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/8/20.
//  Copyright © 2020 zed. All rights reserved.
//

import MapKit

struct MapRect {
	let zoomLevel: Int
	let edges: Edges
	
	var box: [Double] {
		return [
			edges.sw.latitude,
			edges.sw.longitude,
			edges.ne.latitude,
			edges.ne.longitude
		]
	}
}

//typealias Edges = (ne: Double, sw: Double)
typealias Edges = (ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D)

extension MKMapView {
	var zoomLevel: Int {
		// function returns current zoom of the map
		var angleCamera = self.camera.heading
		if angleCamera > 270 {
			angleCamera = 360 - angleCamera
		} else if angleCamera > 90 {
			angleCamera = fabs(angleCamera - 180)
		}
		let angleRad = Double.pi * angleCamera / 180 // camera heading in radians
		let width = Double(self.frame.size.width)
		let height = Double(self.frame.size.height)
		let heightOffset : Double = 20 // the offset (status bar height) which is taken by MapKit into consideration to calculate visible area height
		// calculating Longitude span corresponding to normal (non-rotated) width
		let spanStraight = width * self.region.span.longitudeDelta / (width * cos(angleRad) + (height - heightOffset) * sin(angleRad))
		let doubleValue = log2(360 * ((width / 256) / spanStraight)) + 1
		return Int(doubleValue.rounded())
	}
	
//	Нижний левый - верхний правый, lat/lon
	var edges: Edges {
		let nePoint = CGPoint(x: self.bounds.maxX, y: self.bounds.origin.y)
		let swPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
		let neCoord = convert(nePoint, toCoordinateFrom: self)
		let swCoord = convert(swPoint, toCoordinateFrom: self)
		return (ne: swCoord, sw: neCoord)
	}
	
}
