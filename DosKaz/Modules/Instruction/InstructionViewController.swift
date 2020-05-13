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
		stack.axis = .vertical
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(all: 20)
		return stack
	}()
	
	let textZero = UILabel()
	let textOne = UILabel()
	let textTwo = UILabel()
	let textThree = UILabel()
	
	let titleOne = UILabel()
	let titleTwo = UILabel()
	let titleThree = UILabel()
	
	override func viewDidLoad() {
		navigationItem.title = l10n(.instruction)
		view.backgroundColor = .white
		view.addSubview(scrollView)
		scrollView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		
		scrollView.addSubview(contentView)
		contentView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, .equal, to: .width, of: scrollView)
		
		contentView.addArrangedSubview(textZero)
		contentView.addArrangedSubview(titleOne)

		contentView.addArrangedSubview(textOne)
		contentView.addArrangedSubview(titleTwo)

		contentView.addArrangedSubview(textTwo)
		contentView.addArrangedSubview(titleThree)

		contentView.addArrangedSubview(textThree)
		
		//MARK: Data
		textZero.text = l10n(.instructionTextZero)
		textOne.text = l10n(.greeting1)
		textTwo.text = l10n(.greeting2)
		textThree.text = l10n(.greeting3)
		
		titleOne.text = l10n(.greetingHeading1)
		titleTwo.text = l10n(.greetingHeading2)
		titleThree.text = l10n(.greetingHeading3)
		
		//MARK: Style
		[textZero,textOne,textTwo,textThree].forEach { label in
			label.decorate { (label) in
				label.numberOfLines = 0
			}
		}
		
	}
	
}
