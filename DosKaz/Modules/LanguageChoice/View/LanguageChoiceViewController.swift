//
//  LanguageChoiceViewController.swift
//  LanguageChoice
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-04-07 14:08:05 +0000 lobster.kz. All rights reserved.
//

import UIKit

// MARK: View input protocol

protocol LanguageChoiceViewInput: class {
	func setupInitialState()
	func setupView(with props: LanguageChoiceView.Props)
}

extension LanguageChoiceViewController: LanguageChoiceViewInput {

	func setupInitialState() {
		navigationController?.navigationBar.isHidden = true
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		view.addSubview(rootView)
		rootView.addConstraintsProgrammatically
		.pinToSuperSafeArea()
	}

	func setupView(with props: LanguageChoiceView.Props) {
		rootView.props = props
	}
}


class LanguageChoiceViewController: UIViewController {

	var output: LanguageChoiceViewOutput!
	var rootView = LanguageChoiceView()

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	
	override var shouldAutorotate: Bool {
		return false
	}
	

}

