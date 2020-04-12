//
//  AppDelegate.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/14/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setRootViewController()
		return true
	}
	
	private func setRootViewController() {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = MainTabBarViewController()
		if #available(iOS 13.0, *) {
			window?.overrideUserInterfaceStyle = .light
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


}

