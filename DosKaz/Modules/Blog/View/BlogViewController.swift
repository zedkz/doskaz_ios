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
import SharedCodeFramework

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
	let line1 = UIView()
	let line2 = UIView()
	let similarLabel = UILabel()
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	var cvSource: CollectionViewDataSource<PostCollectionViewCell.Props,PostCollectionViewCell>!
	let cvDelegate = PostCollectionDelegate()
	
	var contentView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 8
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
		return stack
	}()
	
	func setContent(for blog: SingleBlog) {
		navigationItem.title = blog.post.title
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
		let lineColor = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 0.2)
		line1.backgroundColor = lineColor
		line2.backgroundColor = lineColor
		
		let greyText = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 1)
		similarLabel.decorate(with: Style.systemFont(size: 12), { label in
			label.textColor = greyText
		})
		similarLabel.text = l10n(.similarContent)
		configureCollectionView()
		update(with: blog.similar)
		
		let commentsvc = BlogCommentsViewController(blogId: blog.post.id)
		addChild(commentsvc)
		contentView.addArrangedSubview(commentsvc.view)
		commentsvc.didMove(toParent: self)
	}
	
	private func configureCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		collectionView.collectionViewLayout = flowLayout
		collectionView.alwaysBounceHorizontal = true
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .white
		cvSource = CollectionViewDataSource(collectionView) { $1.props = $0 }
		collectionView.dataSource = cvSource
		collectionView.delegate = cvDelegate
	}
	
	private func update(with items: [Item]) {
		let cellsProps = items.map {
			PostCollectionViewCell.Props(
				blog: $0,
				onPickImage: Command {
					print("PostCollectionViewCell picked")
			})
		}
		
		cvSource.cellsProps = cellsProps
		collectionView.reloadData()
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
		
		let insetView = UIView()
		insetView.addSubview(similarLabel)
		similarLabel.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
		
		contentView.addArrangedSubview(imageView)
		contentView.addArrangedSubview(webView)
		contentView.setCustomSpacing(16, after: webView)
		contentView.addArrangedSubview(line1)
		contentView.setCustomSpacing(16, after: line1)
		contentView.addArrangedSubview(insetView)
		contentView.addArrangedSubview(collectionView)
		contentView.setCustomSpacing(16, after: collectionView)
		contentView.addArrangedSubview(line2)
		
		line2.addConstraintsProgrammatically
			.set(my: .height, to: 1)
		
		collectionView.addConstraintsProgrammatically
			.set(my: .height, to: 200)
		
		line1.addConstraintsProgrammatically
			.set(my: .height, to: 1.0)
		
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
			.set(my: .height, to: 400)
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
