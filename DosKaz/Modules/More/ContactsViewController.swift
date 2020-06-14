//
//  ContactsViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/6/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import SharedCodeFramework

class ContactsViewController: UIViewController, DisplaysAlert {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		navigationItem.title = l10n(.contacts)
		configureLayout()
		configureData()
		configureStyle()
	}

	let topImageView = UIImageView()
	let roundedView: UIView = {
		let view = UIView()
		view.backgroundColor = .green
		view.decorate(with: Style.topCornersRounded)
		return view
	}()
	let label1 = UILabel()
	let mail = ContactInfoView()
	let phone = ContactInfoView()
	let facebook = ContactInfoView()
	let instagram = ContactInfoView()
	let writeUsLabel = UILabel()
	let nameForm = TextFormView()
	let email = TextFormView()
	let message = TextFormView(height: 80)
	let sendButton = Button(type: .system)
	let regionalReps = UILabel()
	let tableView = ContentSizedTableView()
	var dataSource: UTableViewDataSource<RegionalRepCell>!
	
	let scrollView = UIScrollView()
	
	var contentView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 10
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 43, left: 20, bottom: 20, right: 20)
		return stack
	}()
	
	private func configureLayout() {
		view.addSubview(scrollView)
		scrollView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		scrollView.addSubview(contentView)
		contentView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, .equal, to: .width, of: scrollView)
		
		contentView.addSubview(topImageView)
		contentView.addSubview(roundedView)
		contentView.addArrangedSubview(label1)
		contentView.setCustomSpacing(56, after: label1)
		contentView.addArrangedSubview(mail)
		contentView.addArrangedSubview(phone)
		contentView.addArrangedSubview(facebook)
		contentView.addArrangedSubview(instagram)
		contentView.setCustomSpacing(30, after: instagram)
		contentView.addArrangedSubview(writeUsLabel)
		
		contentView.addArrangedSubview(nameForm)
		contentView.addArrangedSubview(email)
		contentView.addArrangedSubview(message)
		contentView.addArrangedSubview(sendButton)
		
		contentView.setCustomSpacing(30, after: sendButton)
		contentView.addArrangedSubview(regionalReps)
		contentView.addArrangedSubview(tableView)
		
		sendButton.addConstraintsProgrammatically
			.set(my: .height, to: 56)
		topImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.top)
		roundedView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, to: .bottom, of: label1, plus: 32)
			.pinEdgeToSupers(.bottom)
	}
	
	private func configureData() {
		topImageView.image = UIImage(named: "green_map_background")
		label1.text = l10n(.contactsInfo)
		mail.props = ContactInfoView.Props(imageName: "mail", text: "info@doskaz.kz")
		phone.props = ContactInfoView.Props(imageName: "phone_call", text: "8 (701) 346-21-77")
		facebook.props = ContactInfoView.Props(imageName: "facebook", text: "facebook.com/doskazkz")
		instagram.props = ContactInfoView.Props(imageName: "instagram", text: "instagram.com/doskaz.kz")
		writeUsLabel.text = l10n(.writeToUs)
		
		let _name = TextFormView.Props(
			text: "",
			title: l10n(.yourName),
			onEditText: Text { [weak self] name in
				self?.feedback.name = name
			}
		)
		nameForm.props = _name
		
		let _email = TextFormView.Props(
			text: "",
			title: l10n(.email),
			onEditText: Text { [weak self] name in
				self?.feedback.email = name
			}
		)
		email.props = _email
		
		let _message = TextFormView.Props(
			text: "",
			title: l10n(.textOftheMessage),
			onEditText: Text { [weak self] name in
				self?.feedback.text = name
			}
		)
		message.props = _message
		
		sendButton.isEnabled = false
		sendButton.setTitle(l10n(.send), for: .normal)
		sendButton.didTouchUpInside = { [weak self] in
			guard let self = self else { return }
			if self.isValidEmail(self.feedback.email) {
				self.sendFeedback()
			} else {
				self.displayAlert(with: l10n(.emailIsWrong))
			}
		}
		
		regionalReps.text = l10n(.regionalReps)
		
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.separatorStyle = .none
		loadRegionalReps()
	}
	
	private func loadRegionalReps() {
		APIRegionalReps(
			onSuccess: { [weak self] (reps) in
				self?.dataSource.cellsProps = reps.map { rep in
					RegionalRepCell.Props(regionalRep: rep)
				}
				self?.tableView.reloadData()
			},
			onFailure: { error in
				print(error)
		})
			.dispatch()
	}
	
	private func configureStyle() {
		topImageView.contentMode = .scaleToFill
		label1.decorate(with: Style.systemFont(size: 14), { label in
			label.numberOfLines = 0
			label.textColor = .white
		})
		writeUsLabel.decorate(with: Style.systemFont(size: 20, weight: .semibold))
		sendButton.decorate(with:
			Style.systemFont(size: 14),
			Style.titleColor(color: .white)
		)
		let color = UIColor(named: "SelectedTabbarTintColor") ?? .blue
		sendButton.setBackgroundColor(color, for: .normal)
		sendButton.setBackgroundColor(color.withAlphaComponent(0.3), for: .disabled)
		sendButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
		regionalReps.decorate(with: Style.systemFont(size: 20, weight: .semibold))
	}
	
	//MARK: - Form
	
	var feedback = Feedback(name: "", email: "", text: "") {
		didSet {
			let fields = [feedback.name, feedback.email, feedback.text]
			sendButton.isEnabled = fields.reduce(true) { $0 && !$1.isEmpty }
		}
	}
	
	private func sendFeedback() {
		APIPostFeedback(onSuccess: { [weak self] _ in
			self?.displayAlert(with: l10n(.succeedFormMessage))
		}, onFailure: { [weak self] error in
			print(error)
			self?.displayAlert(with: l10n(.errorMessage))
		},
			 feedback: feedback
		)
			.dispatch()
	}
	
	func isValidEmail(_ email: String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
}
