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
		let cellsProps = blogResponse.items.map {
			BlogCell.Props(
				title: $0.title,
				imageURL: $0.previewImage,
				content: $0.annotation,
				lastLine: $0.publishedAt + "  " + $0.categoryTitle
			)
		}
		view.updateTable(with: cellsProps)
	}
	
	func didFailLoadBlogResponse(with error: Error) {
		view.updateTable(with: [])
	}
}
