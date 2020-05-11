//
//  BigFormViewController.swift
//  BigForm
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-11 07:55:30 +0000 lobster.kz. All rights reserved.
//

import UIKit

// MARK: View input protocol

protocol BigFormViewInput where Self: UIViewController {
	func setupInitialState()
}

extension BigFormViewController: BigFormViewInput {

	func setupInitialState() {
		view.backgroundColor = .white
		navigationItem.title = l10n(.addObject)
	}

}

class BigFormViewController: UIViewController {

	var output: BigFormViewOutput!

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}

}
