//
//  InstructionViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/13/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class InstructionViewController: UIViewController {
	
	let scrollView = UIScrollView()
	var contentView: UIStackView = {
		let stack = UIStackView()
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(all: 20)
		return stack
	}()
	
	let textOne = UILabel()
	
	let titleOne = UILabel()
	let titleTwo = UILabel()
	let titleThree = UILabel()
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		view.addSubview(scrollView)
		scrollView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		
		scrollView.addSubview(contentView)
		contentView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, .equal, to: .width, of: scrollView)
		
		contentView.addArrangedSubview(textOne)
		
		//MARK: Data
		textOne.text = """
		Добро пожаловать!
		
		Приветствуем вас на онлайн-карте «Доступный Павлодар», с помощью которой вы сможете получить информацию о доступности городских объектов и услуг для людей, передвигающимся на креслах-колясках, маломобильных групп населения, а также людей с инвалидностью по зрению и слуху.
		"""
		
	}
	
}
