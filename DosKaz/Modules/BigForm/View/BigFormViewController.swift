//
//  BigFormViewController.swift
//  BigForm
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-11 07:55:30 +0000 lobster.kz. All rights reserved.
//

import SharedCodeFramework

// MARK: View input protocol

protocol BigFormViewInput: DisplaysAlert where Self: UIViewController {
	func setupInitialState()
	var onPressReady: CommandWith<FullForm> { get set }
	func buildForm(with formAttrs: FormAttributes, and categories: [Category])
}

extension BigFormViewController: BigFormViewInput {
	
	func buildForm(with formAttrs: FormAttributes, and categories: [Category]) {
		currentViewController.buildForm(with: formAttrs, and: categories)
	}

	func setupInitialState() {
		//MARK: - Configure constant data
		navigationItem.title = l10n(.addObject)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: l10n(.done), style: .done, target: self, action: #selector(formDone))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: l10n(.close), style: .plain, target: self, action: #selector(closeForm))
		toLeftButton.setImage(UIImage(named: "chevron_left_active"), for: .normal)
		toRightButton.setImage(UIImage(named: "chevron_right_active"), for: .normal)
		
		
		//MARK: - Configure style
		view.backgroundColor = .white
		formTitleLabel.textAlignment = .center
		formTitleLabel.textColor = .systemBlue
		formTitleLabel.decorate(with: Style.systemFont(size: 14))

		//MARK: - Configure behavior
		toLeftButton.addTarget(self, action: #selector(toLeft), for: .touchUpInside)
		toRightButton.addTarget(self, action: #selector(toRight), for: .touchUpInside)
	
		//MARK: - Layout
		view.addSubview(toLeftButton)
		view.addSubview(formTitleLabel)
		view.addSubview(toRightButton)
		
//		toLeftButton.backgroundColor = .yellow
//		toRightButton.backgroundColor = .yellow
		
		formTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		toLeftButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		toRightButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		let height: CGFloat = 40
		let buttonWidth: CGFloat = 28
		toLeftButton.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.top, plus: 12)
			.pinEdgeToSupersSafe(.leading, plus: 20)
			.set(my: .height, to: height)
			.set(my: .width, to: buttonWidth)
		
		formTitleLabel.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: toLeftButton, plus: 8)
			.pin(my: .verticalCenter, andOf: toLeftButton)
			.set(my: .height, to: height)
		
		toRightButton.addConstraintsProgrammatically
			.pin(my: .verticalCenter, andOf: toLeftButton)
			.pin(my: .leading, to: .trailing, of: formTitleLabel, plus: 8)
			.pinEdgeToSupersSafe(.trailing, plus: -20)
			.set(my: .height, to: height)
			.set(my: .width, to: buttonWidth)
		
		// MARK: - Table Views for form
		
		add(asChildViewController: SmallFormViewController())
		currentTitleIndex = 0
	}

	@objc func formDone() {
		guard let hasForm = currentViewController as? HasForm else { return }
		guard let form = hasForm.form else { return }
		print("Form General Information Section: \n", form)
		onPressReady.perform(with: form)
	}
}

class BigFormViewController: UIViewController {

	var output: BigFormViewOutput!
	var onPressReady: CommandWith<FullForm> = .nop

	let toLeftButton = Button()
	let toRightButton = Button()
	let formTitleLabel = UILabel()

	//MARK: - Child view controllers
	private var currentViewController: SmallFormViewController!
	private var formTypes = [FormType.small, FormType.middle, FormType.full]
	
	//MARK: - Titles of tables
	private var titles = [l10n(.formSmall), l10n(.formMedium), l10n(.formFull)]
	private var currentTitleIndex = 0 {
		didSet {
			func update(_ label: UILabel, with text: String) {
				UIView.transition(
					with: label,
					duration: 0.25,
					options: .transitionCrossDissolve,
					animations: { [label] in label.text = text },
					completion: nil
				)
			}
			update(formTitleLabel, with: titles[currentTitleIndex])
			
			currentViewController.formType = formTypes[currentTitleIndex]
		}
	}

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}
	
	@objc func closeForm() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func toLeft() {
		guard currentTitleIndex > 0 else { return }
		currentTitleIndex -= 1
	}
	
	@objc func toRight() {
		guard currentTitleIndex < 2 else { return }
		currentTitleIndex += 1
	}
	
	private func add(asChildViewController viewController: SmallFormViewController) {
		guard viewController != currentViewController else { return }
		
		// If a VC's view was already added to the drawer, remove it.
		if let currentViewController = currentViewController {
			remove(asChildViewController: currentViewController)
		}
		
		currentViewController = viewController

		// Add Child View Controller
		addChild(viewController)
		
		// Add Child View as Subview
		view.addSubview(viewController.view)
		
		// Configure Child View
		viewController.view.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.leading)
			.pinEdgeToSupersSafe(.trailing)
			.pinEdgeToSupersSafe(.bottom)
			.pin(my: .top, to: .bottom, of: toLeftButton, plus: 12)
		
		// Notify Child View Controller
		viewController.didMove(toParent: self)
	}
	
	private func remove(asChildViewController viewController: UIViewController) {
		// Notify Child View Controller
		viewController.willMove(toParent: nil)
		
		// Remove Child View From Superview
		viewController.view.removeFromSuperview()
		
		// Notify Child View Controller
		viewController.removeFromParent()
	}

}

enum FormType {
	case small
	case middle
	case full
}
