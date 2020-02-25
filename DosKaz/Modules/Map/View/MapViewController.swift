//
//  MapViewController.swift
//  Map
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-23 16:55:07 +0000 lobster.kz. All rights reserved.
//

import UIKit

// MARK: View input protocol

protocol MapViewInput: class {
	func setupInitialState()
}

extension MapViewController: MapViewInput {

	func setupInitialState() {
	
	}

}


class MapViewController: UIViewController {

	var output: MapViewOutput!

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}

}
