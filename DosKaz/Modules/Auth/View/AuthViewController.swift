//
//  AuthViewController.swift
//  Auth
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-17 07:43:27 +0000 lobster.kz. All rights reserved.
//

import UIKit
import SharedCodeFramework

enum AuthViewPage {
	case first, second, third
}

// MARK: View input protocol

protocol AuthViewInput where Self: UIViewController {
	func setupInitialState()
	var viewPage: AuthViewPage { get set }
	var onTouchNext: Command { get set }
}

class AuthViewController: UIViewController, AuthViewInput, UITextFieldDelegate {

	var output: AuthViewOutput!
	
	var onTouchNext: Command = .nop
	
	var viewPage = AuthViewPage.first {
		didSet {
			configurePageData()
			
		}
	}
	
	private let backgroundView = UIImageView()
	private let foregroundView = UIView()
	private let logoImageView = UIImageView()
	
	private let topLabel = UILabel()
	private let middleView = UIView()
	private let blueButton = Button(type: .system)
	private let bottomButton = Button(type: .system)
	
	private let phoneTextF = UITextField()
	private let enterPhoneLabel = UILabel()

	func setupInitialState() {
		configureData()
		configureLayout()
		configurePageData()
		configureMiddleViewLayout()
	}
	
	private func configureData() {
		backgroundView.image = UIImage(named: "green_map_background")
		backgroundView.contentMode = .scaleAspectFill
		backgroundView.clipsToBounds = true
		foregroundView.backgroundColor = .white
		foregroundView.decorate(with: Style.topCornersRounded)
		logoImageView.image = UIImage(named: "logo")
		let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
		phoneTextF.leftView = spaceView
		phoneTextF.leftViewMode = .always
		phoneTextF.layer.borderColor = UIColor(named: "TextFieldBorderColor")?.cgColor
		phoneTextF.layer.borderWidth = 1
		phoneTextF.layer.cornerRadius = 3
		phoneTextF.font = .systemFont(ofSize: 14)
		phoneTextF.keyboardType = .phonePad
		phoneTextF.delegate = self
		phoneTextF.addTarget(self, action: #selector(handleTextF(_:)), for: .editingChanged)
		enterPhoneLabel.decorate(with: Style.systemFont(size: 14), { label in
			label.numberOfLines = 0
			label.textAlignment = .center
		})
		topLabel.decorate(with: Style.systemFont(size: 20, weight: .semibold), { label in
			label.numberOfLines = 0
			label.textAlignment = .center
		})
		
		blueButton.decorate(with:
			Style.systemFont(size: 14),
			Style.titleColor(color: .white),
			Style.backgroundColor(color: UIColor.init(named: "SelectedTabbarTintColor"))
		)
		
		blueButton.didTouchUpInside = { [weak self] in
			guard let self = self else { return }
			switch self.viewPage {
			case .first:
				self.onTouchNext.perform()
			case .second:
				break
			case .third:
				break
			}
		}
		
	}
	
	private func configurePageData() {
		switch viewPage {
		case .first:
			topLabel.text = l10n(.auth)
			blueButton.setTitle(l10n(.next), for: .normal)
			bottomButton.setImage(nil, for: .normal)
			bottomButton.setTitle(nil, for: .normal)
			enterPhoneLabel.text = l10n(.enterPhone)
		case .second:
			topLabel.text = l10n(.auth)
			blueButton.setTitle(l10n(.send), for: .normal)
			bottomButton.setImage(UIImage(named: "sms_phone"), for: .normal)
			bottomButton.setTitle(" " + l10n(.getMoreSms), for: .normal)
			enterPhoneLabel.text = l10n(.enterSmsCode)
		case .third:
			topLabel.text = l10n(.welcome)
			blueButton.setTitle(l10n(.toProfile), for: .normal)
			bottomButton.setImage(nil, for: .normal)
			bottomButton.setTitle(l10n(.nextTime), for: .normal)
			enterPhoneLabel.text = nil
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
		
		foregroundView.addSubview(bottomButton)
		bottomButton.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: blueButton, plus: 12)
			.pinEdgeToSupers(.horizontalCenter)

	}
	
	private func configureMiddleViewLayout() {
		switch viewPage {
		case .first:
			middleView.addSubview(phoneTextF)
			middleView.addSubview(enterPhoneLabel)
			phoneTextF.addConstraintsProgrammatically
				.pinEdgeToSupers(.leading, plus: 24)
				.pinEdgeToSupers(.trailing, plus: -24)
				.set(my: .height, to: 56)
				.pinEdgeToSupers(.bottom)
			enterPhoneLabel.addConstraintsProgrammatically
				.pinEdgeToSupers(.horizontalCenter)
				.pin(my: .bottom, to: .top, of: phoneTextF, plus: -20)
		case .second:
			break
		case .third:
			break
		}
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {

	}
	
	@objc func handleTextF(_ textField: UITextField) {
		
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
