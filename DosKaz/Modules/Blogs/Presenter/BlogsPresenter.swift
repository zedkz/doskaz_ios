//
//  BlogsPresenter.swift
//  Blogs
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-05-14 17:21:04 +0000 lobster.kz. All rights reserved.
//
		
class BlogsPresenter {
	
	weak var view: BlogsViewInput!
	var interactor: BlogsInteractorInput!
	var router: BlogsRouterInput!

}

// MARK: ViewController output protocol

protocol BlogsViewOutput {
	func viewIsReady()
}

extension BlogsPresenter: BlogsViewOutput {
	func viewIsReady() {
		view.setupInitialState()
		interactor.loadPosts()
	}

}

// MARK: Interactor output protocol

protocol BlogsInteractorOutput: class {
	func didload(_ blogResponse: BlogResponse)
	func didFailLoadBlogResponse(with error: Error)
}

extension BlogsPresenter: BlogsInteractorOutput {
	func didload(_ blogResponse: BlogResponse) {
		print("Blog post count:", blogResponse.items.count)
		view.updateTable(with: blogResponse.items)
	}
	
	func didFailLoadBlogResponse(with error: Error) {
		view.updateTable(with: [])
	}
}
