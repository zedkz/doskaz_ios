//
//  ProfileViewController.swift
//  Profile
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-18 08:16:13 +0000 lobster.kz. All rights reserved.
//

import UIKit

// MARK: View input protocol

protocol ProfileViewInput where Self: UIViewController {
	func setupInitialState()
}

extension ProfileViewController: ProfileViewInput {

	func setupInitialState() {
		view.backgroundColor = .white
		navigationItem.title = l10n(.myProfile)
	}

}

class ProfileViewController: ProfileDrawerViewController {

	var output: ProfileViewOutput!

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}

}
