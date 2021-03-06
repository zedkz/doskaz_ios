//
//  MapRouter.swift
//  Map
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-02-23 16:55:07 +0000 lobster.kz. All rights reserved.
//

import UIKit

protocol MapRouterInput {
	func presentFilter(with vc: UIViewController)
	func presentBigForm(with vc: UIViewController)
	func presentComplaint(with vc: UIViewController)
}

// MARK: Implementation

class MapRouter: MapRouterInput {
	func presentFilter(with vc: UIViewController) {
		let filter = FilterBuilder().assembleModule()
		let nvc = UINavigationController(rootViewController: filter)
		vc.navigationController?.present(nvc, animated: true, completion: nil)
	}
	
	func presentBigForm(with vc: UIViewController) {
		
		if AppSettings.token == nil {
			let auth = AuthBuilder().assembleModule()
			auth.output.initView(with: .anywhere(.bigForm))
			vc.presentEmbedded(auth)
		} else {
			let form = BigFormBuilder().assembleModule()
			vc.presentEmbedded(form)
		}
		
	}
	
	func presentComplaint(with vc: UIViewController) {
		if AppSettings.token == nil {
			let auth = AuthBuilder().assembleModule()
			auth.output.initView(with: .anywhere(.complaint))
			vc.presentEmbedded(auth)
		} else {
			let complaintViewController = ComplaintBuilder().assembleModule()
			vc.presentEmbedded(complaintViewController)
		}
	}

}


extension UIViewController {
	func presentEmbedded(_ viewController: UIViewController) {
		let nvc = UINavigationController(rootViewController: viewController)
		self.navigationController?.present(nvc, animated: true, completion: nil)
	}
}
