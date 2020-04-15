//
//  LanguageChoiceView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class LanguageChoiceView: UIView {
	
	struct Props {
		
		var chooseKazakh: Command
		var chooseRus: Command
		
		static let zero = Props(
			chooseKazakh: .nop, chooseRus: .nop
		)
	}
	
	struct Subviews {
		
		var backGroundImage = UIImageView()
		var kazakhBtn = Button()
		var rusBtn = Button()
		var logoImage = UIImageView()
		
		func render(with props: Props) {
			
		}
		
		func renderConstantData() {
			backGroundImage.image = UIImage(named: "green_map_background")
			kazakhBtn.setTitle("Қазақша", for: .normal)
			rusBtn.setTitle("Русский", for: .normal)
			logoImage.image = UIImage(named: "logo")
		}
		
		func style() {
			kazakhBtn.decorate(with: Style.languageButton)
			rusBtn.decorate(with: Style.languageButton)
		}
	}
	
	/// Properties
	
	let sv = Subviews()
	
	var props = Props.zero {
		didSet {
			sv.render(with: props)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false

		configureSubViews()
		styleSubviews()
		sv.render(with: Props.zero)
		sv.renderConstantData()
		sv.style()
		LanguageChoiceViewLayout(for: self).paint()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}

/// View configuration, content and styling

extension LanguageChoiceView {
	
	private func styleSubviews() {
		
	}
	
	private func configureSubViews() {
		sv.kazakhBtn.didTouchUpInside = {
			self.props.chooseKazakh.perform()
		}
		
		sv.rusBtn.didTouchUpInside = {
			self.props.chooseRus.perform()
		}
	}
}



/// View layout

struct LanguageChoiceViewLayout {
	
	var rootView: LanguageChoiceView
	var sv: LanguageChoiceView.Subviews
	var logoStack: UIStackView = {
		let stack = UIStackView()
		return stack
	}()
	
	var buttonStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 19
		return stack
	}()

	
	init(for rootView: LanguageChoiceView) {
		self.rootView = rootView
		self.sv = rootView.sv
	}
	
	func paint() {
		addSubViews()
		addConstraints()
	}
	
}

extension LanguageChoiceViewLayout {
	
	func addSubViews() {
		rootView.addSubview(sv.backGroundImage)
		rootView.addSubview(buttonStack)
		buttonStack.addArrangedSubviews([
			sv.kazakhBtn,
			sv.rusBtn
		])
		rootView.addSubview(logoStack)
		logoStack.addArrangedSubview(sv.logoImage)
	}
	
	func addConstraints() {
		sv.backGroundImage.addConstraintsProgrammatically
		.pinToSuper()
		
		buttonStack.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.pin(my: .top, to: .bottom, of: logoStack, plus: 110)
		
		sv.kazakhBtn.addConstraintsProgrammatically
			.set(my: .width, to: 148)
			.set(my: .height, to: 44)
		
		sv.rusBtn.addConstraintsProgrammatically
			.set(my: .width, to: 148)
			.set(my: .height, to: 44)
		
		logoStack.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.pin(my: .top, andOf: rootView, plus: 209)
	}
	
}

