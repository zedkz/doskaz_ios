//
//  LanguageChoiceView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class LanguageChoiceView: UIView {
	
	struct Props {
		
		static let zero = Props(
			
		)
	}
	
	struct Subviews {
		
		var backGroundImage = UIImageView()
		
		func render(with props: Props) {
			
		}
		
		func renderConstantData() {
			backGroundImage.image = UIImage(named: "green_map_background")
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
		
	}
}



/// View layout

struct LanguageChoiceViewLayout {
	
	var rootView: LanguageChoiceView
	var sv: LanguageChoiceView.Subviews
	
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
	}
	
	func addConstraints() {
		sv.backGroundImage.addConstraintsProgrammatically
		.pinToSuper()
	}
	
}




