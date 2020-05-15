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
		stack.spacing = 18
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(all: 24)
		return stack
	}()
	
	let textZero = UILabel()
	let textOne = UILabel()
	let textTwo = UILabel()
	let textThree = UILabel()
	
	let titleOne = UILabel()
	let titleTwo = UILabel()
	let titleThree = UILabel()
	
	
	var picOne: UIImageView = {
		let image = UIImage(named: "ins_pic_1")
		let view = UIImageView(image: image)
		view.contentMode = .scaleAspectFit
		return view
	}()
	
	var picTwo: UIImageView = {
		let image = UIImage(named: "ins_pic_3")
		let view = UIImageView(image: image)
		view.contentMode = .scaleAspectFit
		return view
	}()
	
	var picThree: UIImageView = {
		let image = UIImage(named: "ins_pic_2")
		let view = UIImageView(image: image)
		view.contentMode = .scaleAspectFit
		return view
	}()
	
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
		contentView.addArrangedSubview(picOne)
		contentView.addArrangedSubview(textOne)
		contentView.addArrangedSubview(titleTwo)
		contentView.addArrangedSubview(picTwo)
		contentView.addArrangedSubview(textTwo)
		contentView.addArrangedSubview(titleThree)
		contentView.addArrangedSubview(picThree)
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
			label.decorate(with: Style.systemFont(size: 14) ,{ (label) in
				label.numberOfLines = 0
			})
		}
		
		[titleOne,titleTwo,titleThree].forEach{ label in
			label.decorate(with: Style.systemFont(size: 20, weight: .semibold) ,{ (label) in
				label.numberOfLines = 0
				label.textAlignment = .center

			})
		}
		
	}
	
}
