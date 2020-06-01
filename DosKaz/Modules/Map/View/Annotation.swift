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
				size: CGSize(width: 15, height: 15)
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
	var isLarge = false
	
	init(id: Int, icon: String, color: UIColor, locationName: String, coordinate: CLLocationCoordinate2D) {
		self.id = id
		self.icon = icon
		self.locationName = locationName
		self.coordinate = coordinate
		self.color = color
		super.init()
	}
	
	var title: String? {
		return nil
	}
	
	var subtitle: String? {
		return nil
	}
		
	var imageName: String? {
		return icon
	}
	
}


//MARK: - Clusters

class ClusterAnnotationView: MKAnnotationView {

	let label = UILabel()

	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		image = UIImage(named: "circle")
		
		label.decorate(with: Style.systemFont(size: 12))
		addSubview(label)
		label.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.horizontalCenter)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var annotation: MKAnnotation? {
		willSet {
			guard let cluster = newValue as? ClusterAnnotation else {return}
			label.text = String(cluster.count)
		}
	}
}

class ClusterAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var count: Int
	
	init(point: CLLocationCoordinate2D, count: Int) {
		self.coordinate = point
		self.count = count
	}
	
	var title: String? = "Cluster"
	
	var subtitle: String? = "Buck"
	
}
