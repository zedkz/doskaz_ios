//
//  BlogViewController.swift
//  Blog
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-14 10:27:15 +0000 lobster.kz. All rights reserved.
//

import UIKit
import Kingfisher
import WebKit

// MARK: View input protocol

protocol BlogViewInput where Self: UIViewController {
	func setupInitialState()
	func setContent(for blog: SingleBlog)
}

class BlogViewController: UIViewController, BlogViewInput {

	var output: BlogViewOutput!
	
	let imageView = UIImageView()
	let webView = WKWebView()
	
	let scrollView = UIScrollView()
	let titleLabel = UILabel()
	let subTitleLabel = UILabel()
	
	var contentView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 0
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return stack
	}()
	
	func setContent(for blog: SingleBlog) {
		let url = blog.post.imagURL
		imageView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
		imageView.kf.indicatorType = .activity
		let blur = BlurImageProcessor(blurRadius: 3.5)
		imageView.kf.setImage(
			with: url,
			options: [
				.processor(blur),
				.scaleFactor(UIScreen.main.scale),
				.transition(.fade(1)),
				.cacheOriginalImage
		])
		
		webView.scrollView.isScrollEnabled = false
		webView.navigationDelegate = self
		if let content = blog.post.content {
			webView.loadHTMLString(content, baseURL: nil)
		}
		titleLabel.decorate(with: Style.systemFont(size: 20, weight: .semibold), { label in
			label.adjustsFontSizeToFitWidth = true
			label.textColor = .white
			label.textAlignment = .center
			label.numberOfLines = 0
			label.layer.shadowColor = UIColor.black.cgColor
			label.layer.shadowOffset = CGSize.zero
			label.layer.shadowRadius = 2.0
			label.layer.shadowOpacity = 1.0
		})
		titleLabel.text = blog.post.title
		
		subTitleLabel.decorate(with: Style.systemFont(size: 10), { label in
			label.adjustsFontSizeToFitWidth = true
			label.textColor = .white
			label.textAlignment = .center
			label.numberOfLines = 0
		})
		subTitleLabel.text = blog.post.datePublished + "  " + blog.post.categoryName
	}
	
	func setupInitialState() {
		configureLayout()
	}
	
	var height: NSLayoutConstraint?
	
	private func configureLayout() {
		view.addSubview(scrollView)
		scrollView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		scrollView.addSubview(contentView)
		contentView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, .equal, to: .width, of: scrollView)
		
		contentView.addArrangedSubview(imageView)
		contentView.addArrangedSubview(webView)
		
		imageView.addSubview(titleLabel)
		imageView.addSubview(subTitleLabel)
		titleLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 8)
			.pinEdgeToSupers(.trailing, plus: -8)
			.pinEdgeToSupers(.verticalCenter, plus: 20)
		subTitleLabel.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLabel, plus: 12)
			.pinEdgeToSupers(.leading, plus: 8)
			.pinEdgeToSupers(.trailing, plus: -8)

		imageView.addConstraintsProgrammatically
			.set(my: .height, .equal, to: .width, of: imageView, times: 210/375)
		height = webView.addConstraintsProgrammatically
			.set(my: .height, to: 0)
			.constraint
	}
}

extension BlogViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.height?.constant = webView.scrollView.contentSize.height
		}
	}
}

extension BlogViewController  {
	
	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		output.viewIsReady()
	}
	
}
