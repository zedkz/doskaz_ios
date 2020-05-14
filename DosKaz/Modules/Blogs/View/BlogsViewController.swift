//
//  BlogsViewController.swift
//  Blogs
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-14 17:21:04 +0000 lobster.kz. All rights reserved.
//

import UIKit

// MARK: View input protocol

protocol BlogsViewInput where Self: UIViewController {
	func setupInitialState()
}

extension BlogsViewController: BlogsViewInput {

	func setupInitialState() {
	
	}

}

class BlogsViewController: UIViewController {

	var output: BlogsViewOutput!

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}

}
