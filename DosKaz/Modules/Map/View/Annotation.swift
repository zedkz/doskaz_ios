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
import FontAwesome_swift

class VenueView: MKAnnotationView {
	
	override var annotation: MKAnnotation? {
		willSet {
			guard let venue = newValue as? Venue else {return}
			
			guard let imageName = venue.imageName else { image = nil; return }
			guard let solidImage = UIImage.fontAwesomeIcon(
				code: imageName,
				style: .solid,
				textColor: .white,
				size: CGSize(width: 12, height: 12)
				) else { image = nil; return }
			
			let baseImage = UIImage(named: "mapobject_26_available")?.withRenderingMode(.alwaysTemplate)
			let finalImage = baseImage?.overlayWith(image: solidImage, color: venue.color)
			image = finalImage

		}
	}
	
}



class Venue: NSObject, MKAnnotation {
	let id: Int
	let icon: String?
	let color: UIColor
	let locationName: String
	let coordinate: CLLocationCoordinate2D
	
	init(id: Int, icon: String, color: UIColor, locationName: String, coordinate: CLLocationCoordinate2D) {
		self.id = id
		self.icon = icon
		self.locationName = locationName
		self.coordinate = coordinate
		self.color = color
		super.init()
	}
	
	var title: String? {
		return locationName
	}
	
	var subtitle: String? {
		return locationName
	}
		
	var imageName: String? {
		return icon
	}
	
}


