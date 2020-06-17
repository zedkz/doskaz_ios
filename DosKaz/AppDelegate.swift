//
//  AppDelegate.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/14/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		IQKeyboardManager.shared.enable = true
		FirebaseApp.configure()
		setMockViewController(AuthBuilder().assembleModule())
		return true
	}
	
	private func form() {
		setMockViewController(UINavigationController(rootViewController: BigFormBuilder().assembleModule()))
	}
	
	private func setRootViewController() {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		if #available(iOS 13.0, *) {
			window?.overrideUserInterfaceStyle = .light
		}
		
		let isUserIntroducedToApp = Bool.random()
		if isUserIntroducedToApp {
			window?.rootViewController = MainTabBarViewController()
		} else {
			let introductionFlow = PortraitNavigationController(
				rootViewController:
				LanguageChoiceBuilder().assembleModule()
			)
			window?.rootViewController = introductionFlow
		}
		
	}
	
	private func setMockViewController(_ viewController: UIViewController) {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = viewController
		if #available(iOS 13.0, *) {
			window?.overrideUserInterfaceStyle = .light
		}
	}

	
	func applicationWillTerminate(_ application: UIApplication) {
		FilterStorage.shared.store(Filter.shared)
	}

}


class PortraitNavigationController: UINavigationController {
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	
	override var shouldAutorotate: Bool {
		return false
	}
}
