//
//  BlogPresenter.swift
//  Blog
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-14 10:27:15 +0000 lobster.kz. All rights reserved.
//
		
// MARK: ViewController output protocol

protocol BlogViewOutput {
	func initView(with blog: Item)
	func viewIsReady()
}

class BlogPresenter: BlogViewOutput {
	
	weak var view: BlogViewInput!
	var interactor: BlogInteractorInput!
	var router: BlogRouterInput!
	
	var blog: Item!

	func viewIsReady() {
		view.setupInitialState()
		interactor.loadBlog(with: blog.id)
	}
	
	func initView(with blog: Item) {
		print(blog.title)
		self.blog = blog
	}
	
}


// MARK: Interactor output protocol

protocol BlogInteractorOutput: class {
	func didLoad(_ blog: SingleBlog)
	func didFailLoadBlog(with error: Error)
}

extension BlogPresenter: BlogInteractorOutput {
	func didLoad(_ blog: SingleBlog) {
		
	}
	
	func didFailLoadBlog(with error: Error) {
		
	}
	

}
