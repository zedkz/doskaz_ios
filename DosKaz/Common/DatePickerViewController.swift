//
//  DatePickerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/2/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class DatePickerViewController: UIViewController {
	
	init(onPick: OnPick<Date>) {
		super.init(nibName: nil, bundle: nil)
		self.onPick = onPick
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var onPick: OnPick<Date> = .nop
	var selected: Date?
	
	@objc func dateChanged(_ sender: UIDatePicker) {
		selected = sender.date
	}
	
	private let saveButton = UIButton(type: .system)
	private let picker = UIDatePicker()
	private let dateTitle = UILabel()


	override func viewDidLoad() {
		layout()
		showPicker()
		picker.minuteInterval = 10
		picker.locale = Locale(identifier: "ru_RU")
		picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
		
		view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
		let gestRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		view.addGestureRecognizer(gestRecognizer)
	}
	
	@objc
	func tap() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func done() {
		dismiss(animated: true, completion: {
			guard let selected = self.selected else { return }
			self.onPick.perform(with: selected)
		})
	}
	
	func layout() {
		dateTitle.text = l10n(.date)
		dateTitle.backgroundColor = UIColor.blueGreen
		dateTitle.textColor = .white
		dateTitle.font = UIFont.systemFont(ofSize: 20)
		dateTitle.textAlignment = .center
		saveButton.setTitle(l10n(.save), for: .normal)
		saveButton.setTitleColor(.white, for: .normal)
		saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		saveButton.backgroundColor = UIColor.blueGreen
		saveButton.titleLabel?.textAlignment = .center
		saveButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		
		view.addSubview(stack)
		stack.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.horizontalCenter)
			.pinEdgeToSupers(.leading, plus: 4)
			.pinEdgeToSupers(.trailing, plus: -4)
		
		stack.addArrangedSubview(dateTitle)
		stack.addArrangedSubview(picker)
		stack.addArrangedSubview(saveButton)
		
		dateTitle.addConstraintsProgrammatically
			.set(my: .height, to: 54)
		saveButton.addConstraintsProgrammatically
			.set(my: .height, to: 44)
	}
	
	func showPicker() {
		picker.backgroundColor = UIColor.white
		picker.layer.borderWidth = 0.5
		picker.layer.borderColor = UIColor.blueGreen.cgColor
	}
	
	let stack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fill
		stack.alignment = .fill
		stack.spacing = 0
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		return stack
	}()
	
	
}


extension UIViewController {
	func pick(with onPick: OnPick<Date>) {
		let picker = DatePickerViewController(onPick: onPick)
		picker.modalTransitionStyle = .crossDissolve
		picker.modalPresentationStyle = .overCurrentContext
		self.present(picker, animated: true, completion: nil)
	}
}
