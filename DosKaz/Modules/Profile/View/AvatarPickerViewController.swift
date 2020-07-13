//
//  AvatarPickerViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 7/13/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework
import WebKit

class AvatarPickerViewController: UIViewController, UITableViewDelegate {
	
	static func stack() -> UIStackView {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 8
		stack.distribution = .fillEqually
		stack.alignment = .fill
		return stack
	}
	
	let topStack = AvatarPickerViewController.stack()
	let bottomStack = AvatarPickerViewController.stack()
	
	let mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 8
		return stack
	}()
	
	var onPick: Command = .nop
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.gray.withAlphaComponent(0.9)
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		view.addGestureRecognizer(gestureRecognizer)
		
		view.addSubview(mainStack)
		mainStack.addArrangedSubview(topStack)
		mainStack.addArrangedSubview(bottomStack)
		
		mainStack.addConstraintsProgrammatically
			.pinEdgeToSupers(.bottom, plus: -60)
			.pinEdgeToSupers(.leading, plus: 20)
			.pinEdgeToSupers(.trailing, plus: -20)
		
		topStack.addConstraintsProgrammatically
			.set(my: .height, .equal, to: .width, of: topStack, times: 1/3, plus: -16/3)
		bottomStack.addConstraintsProgrammatically
			.set(my: .height, .equal, to: .width, of: bottomStack, times: 1/3, plus: -16/3)
		
		let onPick = CommandWith<PresetAvatar> { [weak self] avatar in
			APIUpdateAvatarPreset(onSuccess: { (avatar) in
				print(avatar)
				self?.tap()
				self?.onPick.perform()
			}, onFailure: { (error) in
				print(error)
				self?.tap()
				self?.onPick.perform()
			},
				 avatarNumber: avatar
			).dispatch()
		}
		
		[PresetAvatar.one, .two, .three].forEach {
			let avaView = AvatarView(avatar: $0, onPick: onPick)
			topStack.addArrangedSubview(avaView)
		}

		[PresetAvatar.four, .five, .six].forEach {
			let avaView = AvatarView(avatar: $0, onPick: onPick)
			bottomStack.addArrangedSubview(avaView)
		}

	}
	
	@objc
	func tap() {
		dismiss(animated: true, completion: nil)
	}
	
}

extension UIViewController {
	func showAvatarPicker(onPick: Command) {
		let vc = AvatarPickerViewController()
		vc.onPick = onPick
		vc.modalTransitionStyle = .crossDissolve
		vc.modalPresentationStyle = .overCurrentContext
		self.present(vc, animated: true, completion: nil)
	}
}


class AvatarView: UIView {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let webView = WKWebView()
	var avatar: PresetAvatar
	var onPick: CommandWith<PresetAvatar>
	
	init(avatar: PresetAvatar, onPick: CommandWith<PresetAvatar>) {
		self.avatar = avatar
		self.onPick = onPick
		
		super.init(frame: .zero)
		
		addSubview(webView)
		webView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .height, .greaterThanOrEqual, to: 80)
			.set(my: .width, .greaterThanOrEqual, to: 80)
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		addGestureRecognizer(gestureRecognizer)
		webView.isUserInteractionEnabled = false

		webView.clipsToBounds = true
		webView.layer.borderWidth = 2
		webView.layer.borderColor = UIColor(named: "AvatarBorderColor")?.cgColor
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let html = """
		<!DOCTYPE html>
		<html lang="en">
			<head>
				<meta charset="UTF-8"/>
				<meta name='viewport' content='initial-scale=1.0, maximum-scale=3.0, minimum-scale=0.5'/>
				<title>SVG Displayer</title>
				<style>
				html, body, .content {
				height: 100%;
				width: 100%;
				margin:0;
				padding:0;
				}
				</style>
			</head>
			
			<body>
				<div id="content" align="center">
				<img height="\(webView.frame.height)" height="\(webView.frame.width)" src="https://doskaz.vps3.zed.kz/static/presets/av\(avatar.rawValue).svg"/></img>
				</div>
				<div id="END"></div>
			</body>
		</html>
		"""
		webView.loadHTMLString(html, baseURL: nil)
		webView.layer.cornerRadius = webView.frame.height/2
	}
	
	
	@objc func tap() {
		onPick.perform(with: avatar)
	}
	
}
