//
//  ProfileRouter.swift
//  Profile
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-18 08:16:13 +0000 lobster.kz. All rights reserved.
//

import UIKit
import SharedCodeFramework

protocol ProfileRouterInput {
	func openEdit(_ profile: Profile, with vc: UIViewController)
	func openAvatarPicker(with vc: UIViewController, onPick: Command)
}

// MARK: Implementation

class ProfileRouter: ProfileRouterInput {
	func openEdit(_ profile: Profile, with vc: UIViewController) {
		let editVC = UpdateProfileViewController.module
		editVC.output.initView(with: profile)
		vc.presentEmbedded(editVC)
	}
	
	func openAvatarPicker(with vc: UIViewController, onPick: Command) {
		vc.tabBarController?.showAvatarPicker(onPick: onPick)
	}
	
}
