//
//  PickerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/16/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework


typealias OnPick<T> = CommandWith<T>

class PickerViewController<Model>: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
where Model: CustomStringConvertible, Model: Equatable {
	
	init(choices: [Model], currentValue: Model, onPick: OnPick<Model>) {
		super.init(nibName: nil, bundle: nil)
		self.choices = choices
		self.selected = currentValue
		self.onPick = onPick
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var onPick: OnPick<Model> = .nop
	var selected: Model?
	
	private let saveButton = UIButton(type: .system)
	private let picker = UIPickerView()
	private let dateTitle = UILabel()
	
	var choices = [Model]()
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return choices.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return choices.map{ $0.description }[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selected = choices[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 40, height: 44))
		label.lineBreakMode = .byCharWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.text = choices.map{ $0.description }[row]
		return label
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 44
	}

	override func viewDidLoad() {
		layout()
		showPicker()
		picker.dataSource = self
		picker.delegate = self
		
		if let selected = selected, let row = choices.firstIndex(of: selected) {
			picker.selectRow(row, inComponent: 0, animated: false)
		}
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
		dateTitle.text = "Выбор"
		dateTitle.backgroundColor = UIColor.blueGreen
		dateTitle.textColor = .white
		dateTitle.font = UIFont.systemFont(ofSize: 20)
		dateTitle.textAlignment = .center
		saveButton.setTitle("Сохранить", for: .normal)
		saveButton.setTitleColor(.white, for: .normal)
		saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		saveButton.backgroundColor = UIColor.blueGreen
		saveButton.titleLabel?.textAlignment = .center
		saveButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		
		view.addSubview(stack)
		stack.addConstraints([
			equal(view, \UIView.centerXAnchor),
			equal(view, \UIView.centerYAnchor),
		])
		
		stack.addArrangedSubview(dateTitle)
		stack.addArrangedSubview(picker)
		stack.addArrangedSubview(saveButton)
		
		dateTitle.addConstraints([equal(dimension: \UIView.heightAnchor, to: 54)])
		saveButton.addConstraints([equal(dimension: \UIView.heightAnchor, to: 44)])
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
	func pick<T>(with onPick: OnPick<T>, currentValue: T, choices: [T]) where T: CustomStringConvertible, T: Equatable {
		let picker = PickerViewController(
			choices: choices,
			currentValue: currentValue,
			onPick: onPick
		)
		picker.modalTransitionStyle = .crossDissolve
		picker.modalPresentationStyle = .overCurrentContext
		self.present(picker, animated: true, completion: nil)
	}
}

extension UIColor {
	@nonobjc class var white: UIColor {
		return UIColor(white: 1.0, alpha: 1.0)
	}
	@nonobjc class var blueGreen: UIColor {
		return UIColor(red: 0.0, green: 136.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
	}
}
