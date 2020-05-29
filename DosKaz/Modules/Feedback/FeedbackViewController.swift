//
//  FeedbackViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/29/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class FeedbackViewController: UIViewController, UITextViewDelegate, DisplaysAlert {
	
	func textViewDidChange(_ textView: UITextView) {
		let count = textView.text?.count ?? 0
		charactersLeftLabel.text = String(count)
		let shouldEnable = count >= 20
		navigationItem.rightBarButtonItem?.isEnabled = shouldEnable
	}
	
	private let titleLabel = UILabel()
	private let instructionLabel = UILabel()
	private let textView = UITextView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configureNavBar()
		configureSubviews()
		layout()
	}
	
	private func configureNavBar() {
		navigationItem.title = l10n(.writeReview)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: l10n(.done), style: .done, target: self, action: #selector(done))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: l10n(.close), style: .plain, target: self, action: #selector(close))
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func done() {
		let onSuccess = { [weak self] (empty: Empty) -> Void in
			guard let safe = self else { return }
			safe.disPlayAlert(with: l10n(.yourReviewWasReceived), action: {
				safe.close()
			})
		}
		
		let onFailure = { [weak self] (error: Error) -> Void in
			self?.displayAlert(with: error.localizedDescription)
		}
		
		let feedback = Feedback(name: "-", email: "profilehasno@email.com", text: textView.text)
		
		APIPostFeedback(onSuccess: onSuccess, onFailure: onFailure, feedback: feedback).dispatch()
		
	}
	
	private func configureSubviews() {
		titleLabel.text = l10n(.tellUsAboutYourFeelings)
		instructionLabel.text = l10n(.enter20Symbols)
		
		titleLabel.decorate(with: Style.systemFont(size: 14))
		instructionLabel.decorate(with: Style.systemFont(size: 12))
		instructionLabel.textColor = UIColor(named: "UnselectedTabbarTintColor")
		
		textView.becomeFirstResponder()
		textView.setBottomBorder()
		textView.delegate = self
		
		navigationItem.rightBarButtonItem?.isEnabled = false
	}
	
	private func layout() {
		view.addSubview(titleLabel)
		view.addSubview(instructionLabel)
		view.addSubview(textView)
		
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.top, plus: 8)
			.pinEdgeToSupersSafe(.leading, plus: 20)
			.pinEdgeToSupersSafe(.trailing, plus: -20)

		textView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 8)
			.pinEdgeToSupersSafe(.leading, plus: 20)
			.pinEdgeToSupersSafe(.trailing, plus: -20)
			.set(my: .height, .greaterThanOrEqual, to: 180)
		
		instructionLabel.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: textView, plus: 8)
			.pinEdgeToSupersSafe(.leading, plus: 20)
			.pinEdgeToSupersSafe(.trailing, plus: -20)
		
		accessory.addSubview(cancelButton)
		accessory.addSubview(charactersLeftLabel)
		
		cancelButton.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing, plus: 0)
			.pinEdgeToSupers(.verticalCenter)
			.set(my: .width, to: 40)
		
		charactersLeftLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.horizontalCenter)
		
		accessory.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
		textView.inputAccessoryView = accessory
	}
	
	//MARK: - Accessory view for text view
	
	let accessory: UIView = {
		let accessoryView = UIView(frame: .zero)
		accessoryView.backgroundColor = .lightGray
		accessoryView.alpha = 0.6
		return accessoryView
	}()
	
	let cancelButton: UIButton = {
		let cancelButton = UIButton(type: .custom)
		let x = UIImage(named: "clear_search")
		cancelButton.setImage(x, for: .normal)
		cancelButton.setTitleColor(UIColor.red, for: .normal)
		cancelButton.addTarget(self, action:
			#selector(cancelButtonTapped), for: .touchUpInside)
		cancelButton.showsTouchWhenHighlighted = true
		return cancelButton
	}()
	
	let charactersLeftLabel: UILabel = {
		let charactersLeftLabel = UILabel()
		charactersLeftLabel.text = "0"
		charactersLeftLabel.textColor = UIColor.white
		charactersLeftLabel.font = .systemFont(ofSize: 11)
		return charactersLeftLabel
	}()
	
	@objc func cancelButtonTapped() {
		textView.resignFirstResponder()
	}
}


extension UITextView {
	func setBottomBorder() {
		layer.backgroundColor = UIColor.white.cgColor
		layer.masksToBounds = false
		
		layer.shadowColor = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 0.2).cgColor
		layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		layer.shadowOpacity = 1.0
		layer.shadowRadius = 0.0
	}
}
