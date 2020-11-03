//
//  AppDelegate.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 2/14/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import VK_ios_sdk
import FBSDKCoreKit
import MRMailSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let mailRu = MRMailSDK.sharedInstance()
		mailRu.initialize(
			withClientID: "***REMOVED***",
			redirectURI: "***REMOVED***://"
		)
		mailRu.clientSecret = "***REMOVED***"
		mailRu.returnScheme = "***REMOVED***"
		mailRu.resultType = .token
		
		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		IQKeyboardManager.shared.enable = true
		FirebaseApp.configure()
		GIDSignIn.sharedInstance().clientID = "***REMOVED***.apps.googleusercontent.com"
		GIDSignIn.sharedInstance()?.serverClientID = "***REMOVED***.apps.googleusercontent.com"
		setRootViewController()
		return true
	}
	
	func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
		-> Bool {
			VKSdk.processOpen(url, fromApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
			GIDSignIn.sharedInstance().handle(url)
			ApplicationDelegate.shared.application(
				application,
				open: url,
				sourceApplication: options[.sourceApplication] as? String,
				annotation: options[.annotation]
			)
			MRMailSDK.sharedInstance().handle(
				url,
				sourceApplication: options[.sourceApplication] as? String,
				annotation: options[.annotation]
			)
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
		
		let isUserIntroducedToApp = AppSettings.isUserIntroducedToApp
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


 class dAppDelegate: UIResponder, UIApplicationDelegate {
	
	
	func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application(
		app,
		open: url,
		sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
		annotation: options[UIApplication.OpenURLOptionsKey.annotation]
		)
		
	}
	
}

