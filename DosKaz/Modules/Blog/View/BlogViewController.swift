//
//  BlogViewController.swift
//  Blog
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-14 10:27:15 +0000 lobster.kz. All rights reserved.
//

import UIKit

// MARK: View input protocol

protocol BlogViewInput where Self: UIViewController {
	func setupInitialState()
}

class BlogViewController: UIViewController, BlogViewInput {

	var output: BlogViewOutput!
	
	let scrollView = UIScrollView()
	
	var contentView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 0
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return stack
	}()
	
	func setupInitialState() {
		configureLayout()
	}
	
	private func configureLayout() {
		view.addSubview(scrollView)
		scrollView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		scrollView.addSubview(contentView)
		contentView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, .equal, to: .width, of: scrollView)
		
	}
}

extension BlogViewController  {
	
	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}
	
}
