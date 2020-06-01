//
//  LargeVenueView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/1/20.
//  Copyright © 2020 zed. All rights reserved.
//

import MapKit

class LargeVenueView: MKAnnotationView {
	
	override var annotation: MKAnnotation? {
		willSet {
			setImage()
		}
	}
	
	func setImage() {
		guard let venue = annotation as? Venue else {return}
		
		guard let imageName = venue.imageName else { image = nil; return }
		guard let solidImage = UIImage.fontAwesomeIcon(
			code: imageName,
			style: .solid,
			textColor: .white,
			size: CGSize(width: 15, height: 15)
			) else { image = nil; return }
		
		let baseImage = UIImage(named: "mapobject_selected_available")?.withRenderingMode(.alwaysTemplate)
		let finalImage = baseImage?.overlayWith(image: solidImage, color: venue.color)
		image = finalImage
	}
	
}
