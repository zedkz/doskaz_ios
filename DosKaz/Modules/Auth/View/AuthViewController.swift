//
//  AuthViewController.swift
//  Auth
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-17 07:43:27 +0000 lobster.kz. All rights reserved.
//

import UIKit
import SharedCodeFramework
import GoogleSignIn
import AuthenticationServices
import VK_ios_sdk
import FBSDKLoginKit

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
	
	var onSignIn: CommandWith<(String, Provider)> { get set }
	var onSignInWithApple: CommandWith<String> { get set }
}

class AuthViewController: UIViewController, AuthViewInput, UITextFieldDelegate {

	var output: AuthViewOutput!
	
	var onTouchNext: CommandWith<String> = .nop
	var onTouchSend: CommandWith<String> = .nop
	var onTouchResend: Command = .nop
	var onTouchToProfile: Command = .nop
	var onTouchNotNow: Command = .nop
	
	var onSignIn: CommandWith<(String, Provider)> = .nop
	var onSignInWithApple: CommandWith<String> = .nop
	
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
	let socialButtonsStack = UIStackView()

	func setupInitialState() {
		configureData()
		configureLayout()
		configurePageData()
		configureMiddleViewLayout()
		navigationController?.navigationBar.isHidden = true
		GIDSignIn.sharedInstance()?.presentingViewController = self
		GIDSignIn.sharedInstance().delegate = self
		
		let vk = VKSdk.initialize(withAppId: "***REMOVED***")
		vk?.register(self)
		vk?.uiDelegate = self
	}
	
	@objc func vksignin() {
		VKSdk.wakeUpSession(["email", "offline"]) { [weak self] (state, error) in
			guard let self = self else { return }
			
			switch state {
			case .authorized:
				print("VK authorized")
				self.onSignIn.perform(with: (VKSdk.accessToken().accessToken, .vk))
			default:
				print("VK unauthorized")
				VKSdk.authorize(["email", "offline"])
			}
		}
	}
	
	
	@objc func facebookLogin() {
		let manager = LoginManager()
		let perms = ["public_profile", "email"]
		manager.logIn(permissions: perms, from: self) { [weak self] (result, error) in
			guard let self = self else { return }
			
			if let error = error {
				print("Facebook Log In Error:", error)
				return
			}
			
			guard let token = result?.token else { return }
			self.onSignIn.perform(with: (token.tokenString, .facebook))
		}
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
					let clear = PhoneFormatter().getClearNumber(number: text)
					self.onTouchNext.perform(with: "+\(clear)")
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
			#if DEBUG
				phoneTextF.text = "+77071012233"
			#else
				phoneTextF.text = "+7"
			#endif
			topLabel.text = l10n(.auth)
			blueButton.setTitle(l10n(.next), for: .normal)
			bottomButton.setImage(nil, for: .normal)
			bottomButton.setTitle(nil, for: .normal)
			enterPhoneLabel.text = l10n(.enterPhone)
			ai.stopAnimating()
			blueButton.isEnabled = true
		case .second:
			#if DEBUG
				phoneTextF.text = "123456"
			#else
				phoneTextF.text = nil
			#endif
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
	
	private func socialButton(_ imageName: String) -> UIButton {
		let button = UIButton(type: .system)
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.systemBlue.cgColor
		button.layer.cornerRadius = 4
		button.addConstraintsProgrammatically
			.set(my: .width, to: 41)
			.set(my: .height, to: 41)
		button.setBackgroundImage(UIImage(named: imageName), for: .normal)
		return button
	}
	
	private func configureMiddleViewLayout() {
		switch viewPage {
		case .first:
			smsInfo.removeFromSuperview()
			let signInButton = GIDSignInButton()
			signInButton.style = .iconOnly
			signInButton.colorScheme = .dark
			
			socialButtonsStack.axis = .horizontal
			socialButtonsStack.distribution = .fillProportionally
			socialButtonsStack.alignment = .center
			socialButtonsStack.spacing = 4
			
			socialButtonsStack.removeFromSuperview()
			middleView.addSubview(socialButtonsStack)
			socialButtonsStack.addConstraintsProgrammatically
				.pinEdgeToSupers(.top)
				.set(my: .leading, .greaterThanOrEqual, to: .leading, of: middleView)
				.set(my: .trailing, .lessThanOrEqual, to: .trailing, of: middleView)
				.pinEdgeToSupers(.horizontalCenter)
				.pin(my: .bottom, to: .top, of: enterPhoneLabel,plus: -8)
				.set(my: .height, to: 48)
			socialButtonsStack.arrangedSubviews.forEach {
				$0.removeFromSuperview()
			}
			
			// Sign in with Apple
			if #available(iOS 13.0, *) {
				let button = UIButton(type: .system)
				button.layer.cornerRadius = 5
				button.clipsToBounds = true
				button.backgroundColor = .black
				button.setImage(UIImage(named: "White Logo Square"), for: .normal)
				button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
				button.addConstraintsProgrammatically
					.set(my: .width, to: 42)
					.set(my: .height, to: 42)
				socialButtonsStack.addArrangedSubview(button)
			}
			
			socialButtonsStack.addArrangedSubview(signInButton)
			
			let vkb = socialButton("vk")
			vkb.addTarget(self, action: #selector(vksignin), for: .touchUpInside)
			socialButtonsStack.addArrangedSubview(vkb)
			
			let fcb = socialButton("facebook_auth")
			fcb.addTarget(self, action: #selector(facebookLogin), for: .touchUpInside)
			socialButtonsStack.addArrangedSubview(fcb)
		case .second:
			socialButtonsStack.removeFromSuperview()
			middleView.addSubview(smsInfo)
			smsInfo.addConstraintsProgrammatically
				.pinEdgeToSupers(.top)
				.pinEdgeToSupers(.leading, plus: 8)
				.pinEdgeToSupers(.trailing, plus: -8)
		case .third:
			socialButtonsStack.removeFromSuperview()
			smsInfo.removeFromSuperview()
			let stack = UIStackView()
			stack.axis = .vertical
			stack.alignment = .fill
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
		guard let text = textField.text else { return }
		if case AuthViewPage.first = viewPage {
			textField.text = PhoneFormatter.format(phoneNumber: text)
		}
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

extension AuthViewController: GIDSignInDelegate {
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
		if let error = error {
			print("Error in google sign in", error.localizedDescription)
			return
		}
		
		guard let token = user.authentication.idToken else { return }
		onSignIn.perform(with: (token, .google))
	}
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		print("User disconnected from google")
	}
}

// MARK: Sign in with Apple handler

@available(iOS 13.0, *)
extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	
	@objc func handleAuthorizationAppleIDButtonPress() {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]
		
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
	
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return self.view.window!
	}
	
	// MARK: - ASAuthorizationControllerDelegate
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			guard let appleIDToken = appleIDCredential.identityToken else {
				print("Unable to fetch identity token")
				return
			}
			
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
				return
			}
			
			let userIdentifier = appleIDCredential.user
			let fullName = appleIDCredential.fullName
			let email = appleIDCredential.email
			
			print(idTokenString)
			print(userIdentifier)
			print(fullName ?? "name is nil")
			print(email ?? "email is nil")
			
			onSignInWithApple.perform(with: idTokenString)
		}
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		guard let error = error as? ASAuthorizationError else {
			return
		}
		
		switch error.code {
		case .canceled:
			print("Canceled")
		case .unknown:
			print("Unknown")
		case .invalidResponse:
			print("Invalid Respone")
		case .notHandled:
			print("Not handled")
		case .failed:
			print("Failed")
		@unknown default:
			print("Default")
		}
	}
}

extension AuthViewController: VKSdkDelegate, VKSdkUIDelegate {
	func vkSdkShouldPresent(_ controller: UIViewController!) {
		present(controller, animated: true)
	}
	
	func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
		let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
		vc?.present(in: self)
	}
	
	func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
		if let error = result.error {
			print("Vkontante Sign In error:", error)
			return
		}
		
		onSignIn.perform(with: (result.token.accessToken, .vk))
	}
	
	func vkSdkUserAuthorizationFailed() {
		print("vkSdkUserAuthorizationFailed")
	}
}
