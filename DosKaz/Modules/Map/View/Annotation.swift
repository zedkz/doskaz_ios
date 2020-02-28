//
//  Annotation.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/28/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class VenueView: MKAnnotationView {
	
	override var annotation: MKAnnotation? {
		willSet {
			guard let venue = newValue as? Venue else {return}
			
			if let imageName = venue.imageName {
				image = UIImage(named: imageName)
			} else {
				image = nil
			}

		}
	}
	
}



class Venue: NSObject, MKAnnotation {
	let title: String?
	let locationName: String
	let coordinate: CLLocationCoordinate2D
	
	init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.locationName = locationName
		self.coordinate = coordinate
		
		super.init()
	}
	
	
	var subtitle: String? {
		return locationName
	}
		
	var imageName: String? {
		return "marker_example"
	}
	
}



