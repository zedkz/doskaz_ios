//
//  BasicCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/1/20.
//  Copyright © 2020 zed. All rights reserved.
//

/// MARKs
/// //MARK: -inits
/// //MARK: - Sub types
/// //MARK: - Public properties and methods
/// //MARK: - Private
/// //MARK: - Layout

import UIKit
import FontAwesome_swift
import Eureka
import SharedCodeFramework

final class FormTextRow: Row<BasicCell>, RowType {
	required init(tag: String?) {
		super.init(tag: tag)
		displayValueFor = { (row) -> String? in
			return nil
		}
	}
}

class ReverseButton: Button {
		
	override func layoutSubviews() {
		super.layoutSubviews()
		if let imageView = imageView, let titleLabel = titleLabel {
			let imw = imageView.frame.width
			let tlw = titleLabel.frame.width


			contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
			titleEdgeInsets = UIEdgeInsets(top: 0, left: -((imw*2) + 8) , bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -tlw*2)
		}
	}
	
}

class BasicCell: Cell<BasicCell.Props>, CellType {
	
	//MARK: -inits
	required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureConstantData()
		configureStyle()
		configureBehaviour()
		BasicCellLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: Eureka methods
	
	override func setup() {
		super.setup()
	}
	
	override func update() {
		super.update()
		props = row.value
	}
	
	//MARK: - Sub types
	
	struct Props {
		let text: String
		let icon: Asset?
		var rightIcon: String
		var onRightButtonTouch: Command = .nop
	}
	
	func update<T>(_ path: WritableKeyPath<BasicCell.Props, T>, with value: T) {
		props[keyPath: path] = value
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			guard let props = props else { return }
			label.text = props.text
			leftImageView.image = props.icon?.image
			button.setImage(UIImage(named: props.rightIcon), for: .normal)
		}
	}
	
	let leftImageView = UIImageView()
	let label = UILabel()
	let button = ReverseButton()
	
	//MARK: - Private
	
	private func configureConstantData() {
		button.decorate(with: Style.titleColor(color: .black))
	}
	
	private func configureStyle() {
		selectionStyle = .none
		label.decorate(with: Style.multiline())
		leftImageView.contentMode = .center
	}
	
	private func configureBehaviour() {
		
		button.didTouchUpInside = { 
			print("Right button pressed")
		}
		let tapG = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapG)
		button.isUserInteractionEnabled = false
	}
	
	@objc func handleTap() {
		self.props.onRightButtonTouch.perform()
	}
	
}

extension BasicCell.Props: Equatable {
	static func == (lhs: BasicCell.Props, rhs: BasicCell.Props) -> Bool {
		return lhs.text == rhs.text &&
			lhs.icon == rhs.icon &&
			lhs.rightIcon == rhs.rightIcon
	}
}

//MARK: - Layout

struct BasicCellLayout {
	weak var rv: BasicCell!
	let wrapperView = UIView()
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension BasicCellLayout {
	private func addSubviews() {
		rv.contentView.addSubview(wrapperView)
		wrapperView.addSubview(rv.leftImageView)
		wrapperView.addSubview(rv.label)
		wrapperView.addSubview(rv.button)
	}
	
	private func addConstraints() {
		
		wrapperView.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))

		rv.leftImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.top)
			.set(my: .width, .equal, to: .height, of: rv.leftImageView)
			.set(my: .bottom, .lessThanOrEqual, to: .bottom, of: wrapperView)
			.set(my: .width, to: 24)

		rv.label.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: rv.leftImageView, plus: 16)
			.pin(my: .trailing, to: .leading, of: rv.button, plus: -12)
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.bottom)
		
		rv.button.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing)
			.pin(my: .verticalCenter, andOf: rv.leftImageView)
			.set(my: .width, .equal, to: .height, of: rv.button)
		
	}
}


