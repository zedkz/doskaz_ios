//
//  Templates.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/3/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class TemplateView: UIView {
	
	//MARK: -inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		configureConstantData()
		configureStyle()
		configureBehaviour()
		TemplateViewLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	//MARK: - Private
	
	private func configureConstantData() {
		
	}
	
	private func configureStyle() {
		
	}
	
	private func configureBehaviour() {
		
	}
	
	// MARK: - Sub types
	
	
}

struct TemplateViewLayout {
	weak var rv: TemplateView!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension TemplateViewLayout {
	
	func addSubviews() {
		
	}
	
	func addConstraints() {
		
	}
	
}


class ShortTemplateView: UIView {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		
		//MARK: - Configure constant data
		//MARK: - Configure style
		//MARK: - Configure behavior
		//MARK: - Layout
		
	}
	
	//MARK: - Public properties and methods
	
	//MARK: - Sub types
	
}

