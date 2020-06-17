//
//  AuthViewController.swift
//  Auth
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-17 07:43:27 +0000 lobster.kz. All rights reserved.
//

import UIKit

enum AuthViewPage {
	case first, second, third
}

// MARK: View input protocol

protocol AuthViewInput where Self: UIViewController {
	func setupInitialState()
}

class AuthViewController: UIViewController, AuthViewInput {

	var output: AuthViewOutput!
	
	private var viewPage = AuthViewPage.first
	private let backgroundView = UIImageView()
	private let foregroundView = UIView()
	private let logoImageView = UIImageView()
	
	private let topLabel = UILabel()
	private let middleView = UIView()
	private let blueButton = Button(type: .system)
	private let bottomButton = Button(type: .system)

	func setupInitialState() {
		configureData()
		configurePageData()
		configureLayout()
	}
	
	private func configureData() {
		backgroundView.image = UIImage(named: "green_map_background")
		backgroundView.contentMode = .scaleAspectFill
		backgroundView.clipsToBounds = true
		foregroundView.backgroundColor = .white
		foregroundView.decorate(with: Style.topCornersRounded)
		logoImageView.image = UIImage(named: "logo")
	}
	
	private func configurePageData() {
		topLabel.decorate(with: Style.systemFont(size: 20, weight: .semibold), { label in
			label.numberOfLines = 0
			label.textAlignment = .center
		})
		
		blueButton.decorate(with:
			Style.systemFont(size: 14),
			Style.titleColor(color: .white),
			Style.backgroundColor(color: UIColor.init(named: "SelectedTabbarTintColor"))
		)
		
		blueButton.didTouchUpInside = {
			
		}
		
		switch viewPage {
		case .first:
			topLabel.text = l10n(.auth)
			blueButton.setTitle(l10n(.next), for: .normal)
		case .second:
			topLabel.text = l10n(.auth)
			blueButton.setTitle(l10n(.send), for: .normal)
		case .third:
			topLabel.text = l10n(.welcome)
			blueButton.setTitle(l10n(.toProfile), for: .normal)
		}
	}

	private func configureLayout() {
		view.addSubview(backgroundView)
		view.addSubview(foregroundView)
		
		backgroundView.addConstraintsProgrammatically.pinToSuperSafeArea()
		foregroundView.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.bottom)
			.pinEdgeToSupersSafe(.leading)
			.pinEdgeToSupersSafe(.trailing)
			.set(my: .height, .equal, to: .height, of: view, times: 507/647)
		
		let logoContainer = UIView()
		view.addSubview(logoContainer)
		logoContainer.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.leading)
			.pinEdgeToSupersSafe(.trailing)
			.pinEdgeToSupersSafe(.top)
			.pin(my: .bottom, to: .top, of: foregroundView)
		
		logoContainer.addSubview(logoImageView)
		logoImageView.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.verticalCenter)
			.pinEdgeToSupersSafe(.horizontalCenter)
		
		configureForegroundLayout()
	}
	
	private func configureForegroundLayout() {
		foregroundView.addSubview(topLabel)
		topLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing, plus: -8)
			.pinEdgeToSupers(.leading, plus: 8)
			.pinEdgeToSupers(.top, plus: 35)
		
		middleView.backgroundColor = .systemGray
		foregroundView.addSubview(middleView)
		middleView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: topLabel, plus: 20)
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.set(my: .height, to: 176 + 48)
		
		foregroundView.addSubview(blueButton)
		blueButton.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: middleView, plus: 20)
			.pinEdgeToSupers(.leading, plus: 24)
			.pinEdgeToSupers(.trailing, plus: -24)
			.set(my: .height, to: 56)

	}
	
}

extension AuthViewController {

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}

}
