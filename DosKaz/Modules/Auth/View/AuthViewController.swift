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
	case first, second, third(AuthOrigin), loading
}

// MARK: View input protocol

protocol AuthViewInput: DisplaysAlert where Self: UIViewController {
	func setupInitialState()
	var viewPage: AuthViewPage { get set }
	var onTouchNext: CommandWith<String> { get set }
	var onTouchSend: CommandWith<String> { get set }
	var onTouchToProfile: Command { get set }
	var onTouchResend: Command { get set }
	var onTouchNotNow: Command { get set }
}

class AuthViewController: UIViewController, AuthViewInput, UITextFieldDelegate {

	var output: AuthViewOutput!
	
	var onTouchNext: CommandWith<String> = .nop
	var onTouchSend: CommandWith<String> = .nop
	var onTouchResend: Command = .nop
	var onTouchToProfile: Command = .nop
	var onTouchNotNow: Command = .nop
	
	var viewPage = AuthViewPage.first {
		didSet {
			configurePageData()
			configureMiddleViewLayout()
		}
	}
	
	private let backgroundView = UIImageView()
	private let foregroundView = UIView()
	private let logoImageView = UIImageView()
	
	private let topLabel = UILabel()
	private let middleView = UIView()
	private let blueButton = Button(type: .system)
	private let bottomButton = Button(type: .system)
	private let xButton = Button(type: .system)
	
	private let phoneTextF = UITextField()
	private let enterPhoneLabel = UILabel()
	var ai: UIActivityIndicatorView = {
		let ai = UIActivityIndicatorView(style: .white)
		ai.hidesWhenStopped = true
		return ai
	}()
	
	let contRegLabel = UILabel()
	let twentyP = AuthInfoView()
	let fiftyP = AuthInfoView()
	
	let smsInfo = AuthInfoView()

	func setupInitialState() {
		configureData()
		configureLayout()
		configurePageData()
		configureMiddleViewLayout()
		navigationController?.navigationBar.isHidden = true
	}
	
	private func configureData() {
		
		phoneTextF.keyboardDistanceFromTextField = 82
		
		let tc = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 1)
		smsInfo.props = AuthInfoView.Props(imageName: "auth_i", text: l10n(.smsInfo), textColor: tc)
		
		contRegLabel.text = l10n(.continueReg)
		contRegLabel.decorate(with: Style.systemFont(size: 14, weight: .semibold), { label in
			label.numberOfLines = 0
			label.textAlignment = .center
		})
		
		twentyP.props = AuthInfoView.Props(imageName: "20_points", text: l10n(.getTwentyPoints))
		fiftyP.props = AuthInfoView.Props(imageName: "50_points", text: l10n(.getFiftyPoints))
		
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
		
		let x = UIImage(named: "x_in_form")?.withRenderingMode(.alwaysTemplate)
		xButton.tintColor = .white
		xButton.setImage(x, for: .normal)
		xButton.didTouchUpInside = { [unowned self] in
			self.dismiss(animated: true, completion: nil)
		}
		
		
		bottomButton.didTouchUpInside = { [weak self] in
			guard let self = self else { return }

			switch self.viewPage {
			case .second:
				self.onTouchResend.perform()
			case .third:
				self.onTouchNotNow.perform()
			default: break
			}
		}
		
		blueButton.didTouchUpInside = { [weak self] in
			guard let self = self else { return }
			self.phoneTextF.resignFirstResponder()
			switch self.viewPage {
			case .first:
				if let text = self.phoneTextF.text, !text.isEmpty {
					self.onTouchNext.perform(with: text)
				}
			case .second:
				if let text = self.phoneTextF.text, !text.isEmpty {
					self.onTouchSend.perform(with: text)
				}
			case .third:
				self.onTouchToProfile.perform()
			case .loading:
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
			ai.stopAnimating()
			blueButton.isEnabled = true
		case .second:
			phoneTextF.text = nil
			topLabel.text = l10n(.auth)
			blueButton.setTitle(l10n(.send), for: .normal)
			bottomButton.setImage(UIImage(named: "sms_phone"), for: .normal)
			bottomButton.setTitle(" " + l10n(.enterNumberAgain), for: .normal)
			enterPhoneLabel.text = l10n(.enterSmsCode)
			ai.stopAnimating()
			blueButton.isEnabled = true
		case .third(let origin):
			phoneTextF.isHidden = true
			topLabel.text = l10n(.welcome)
			blueButton.setTitle(l10n(.toProfile), for: .normal)
			bottomButton.setImage(nil, for: .normal)
			bottomButton.setTitle(l10n(.nextTime), for: .normal)
			enterPhoneLabel.text = nil
			ai.stopAnimating()
			blueButton.isEnabled = true
			if case .tab = origin {
				bottomButton.isHidden = true
			}
		case .loading:
			ai.startAnimating()
			blueButton.isEnabled = false
			blueButton.setTitle(nil, for: .normal)
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
			.set(my: .height, .equal, to: .height, of: backgroundView, times: 507/647)
		
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
		
		view.addSubview(xButton)
		xButton.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.trailing, plus: -8)
			.pinEdgeToSupersSafe(.top, plus: 8)
			.set(my: .height, to: 22)
			.set(my: .width, to: 22)
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
			.set(my: .height, to: 176)
		
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
		
		blueButton.addSubview(ai)
		ai.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.horizontalCenter)
	}
	
	private func configureMiddleViewLayout() {
		switch viewPage {
		case .first:
			smsInfo.removeFromSuperview()
		case .second:
			middleView.addSubview(smsInfo)
			smsInfo.addConstraintsProgrammatically
				.pinEdgeToSupers(.top)
				.pinEdgeToSupers(.leading, plus: 8)
				.pinEdgeToSupers(.trailing, plus: -8)
		case .third:
			smsInfo.removeFromSuperview()
			let stack = UIStackView()
			stack.axis = .vertical
			stack.alignment = .leading
			stack.isLayoutMarginsRelativeArrangement = true
			stack.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
			middleView.addSubview(stack)
			stack.addConstraintsProgrammatically
				.pinEdgeToSupers(.top)
				.pinEdgeToSupers(.leading)
				.pinEdgeToSupers(.trailing)
			stack.addArrangedSubview(contRegLabel)
			stack.setCustomSpacing(41, after: contRegLabel)
			stack.addArrangedSubview(twentyP)
			stack.addArrangedSubview(fiftyP)
		case .loading:
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