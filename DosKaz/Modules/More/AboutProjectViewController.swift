//
//  AboutProjectViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/30/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class AboutProjectViewController: UIViewController {

	private func configureNavigationBar() {
		navigationItem.title = l10n(.aboutProject)
	}
	
	let scrollView = UIScrollView()
	var contentView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 10
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 117, left: 20, bottom: 20, right: 20)
		return stack
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		scrollView.alwaysBounceVertical = true
		configureNavigationBar()
		configureData()
		configureStyle()
		configureLayout()
	}
	
	let topImage = UIImageView()
	let headingWhatIsThisProject = UILabel()
	let textWhatIsThisProject = UILabel()
	let headingHowMapWorks = UILabel()
	let textHowMapWorks = UILabel()
	let greenCard = AboutCardView()
	let yellowCard = AboutCardView()
	let redCard = AboutCardView()
	let headingParticipate = UILabel()
	let womanImage = UIImageView()
	let textParticipate = UILabel()
	let headingWhyNeedMap = UILabel()
	let whyNeedMap = TextAroundImageView()
	let whyNeedMap2 = TextAroundImageView()
	let whyNeedMap3 = TextAroundImageView()
	let headingProjectUsefull = UILabel()
	let textProjectUsefull = UILabel()
	let headingPartners = UILabel()
	let textPartners = UILabel()
	let partnerImage1 = UIImageView()
	let partnerImage2 = UIImageView()
	let partnerImage3 = UIImageView()
	
	let headingFinancing = UILabel()
	let textFinancing = UILabel()
	
	let financeImage1 = UIImageView()
	let financeImage2 = UIImageView()

	private func configureData() {
		topImage.image = UIImage(named: "background2")
		headingWhatIsThisProject.text = l10n(.aboutHeadingWhatIsThisProject) + "\n" + l10n(.doskaz)
		textWhatIsThisProject.text = l10n(.aboutTextWhatIsThisProject)
		headingHowMapWorks.text = l10n(.aboutHowMapWorks)
		textHowMapWorks.text = l10n(.aboutTextHowMapWorks)
		greenCard.props = Card(image: "available_32", title: l10n(.accessibleFull), text: l10n(.aboutAvailable))
		yellowCard.props = Card(image: "partially_available_32", title: l10n(.accessiblePartial), text: l10n(.aboutPartial))
		redCard.props = Card(image: "not_available_32", title: l10n(.accessibleNone), text: l10n(.aboutNotAvailable))
		headingParticipate.text = l10n(.aboutParticipate)
		womanImage.image = UIImage(named: "about_pic")
		textParticipate.text = l10n(.aboutTextParticipate)
		
		headingWhyNeedMap.text = l10n(.aboutHeadingWhyNeedMap)
		whyNeedMap.props = About(image: "about_pic2", text: l10n(.aboutWhyNeedMap))
		whyNeedMap2.props = About(image: "about_pic3", text: l10n(.aboutWhyNeedMap2))
		whyNeedMap3.props = About(image: "about_pic4", text: l10n(.aboutWhyNeedMap3))
		
		headingProjectUsefull.text = l10n(.aboutHeadingProjectUsefull)
		textProjectUsefull.text = l10n(.aboutTextProjectUsefull)
		
		headingPartners.text = l10n(.aboutHeadingPartners)
		textPartners.text = l10n(.aboutTextPartners)
		
		partnerImage1.image = UIImage(named: "about_efca")
		partnerImage2.image = UIImage(named: "about_tandau")
		partnerImage3.image = UIImage(named: "about_erekshe")
		
		headingFinancing.text = l10n(.aboutHeadingFinancing)
		textFinancing.text = l10n(.aboutTextFinancing)
		
		financeImage1.image = UIImage(named: "about_eu")
		financeImage2.image = UIImage(named: "about_dip")
	}
	
	private func configureStyle() {
		
		womanImage.contentMode = .scaleAspectFit
		
		let views = [
			headingWhatIsThisProject,
			headingHowMapWorks,
			headingParticipate,
			headingWhyNeedMap,
			headingProjectUsefull,
			headingPartners,
			headingFinancing
		]
		
		views.forEach { label in
			label.decorate(with: Style.systemFont(size: 20, weight: .semibold), { (label) in
				label.numberOfLines = 0
				label.textAlignment = .center
			})
		}
		
		topImage.contentMode = .scaleToFill
		
		let smallTexts = [
			textWhatIsThisProject,
			textHowMapWorks,
			textParticipate,
			textProjectUsefull,
			textPartners,
			textFinancing
		]

		smallTexts.forEach { label in
			label.decorate(with: Style.systemFont(size: 14), { (label) in
				label.numberOfLines = 0
			})
		}
		
	}
	
	private func configureLayout() {
		let roundedView = UIView()
		roundedView.decorate(with: Style.topCornersRounded)
				
		view.addSubview(scrollView)
		scrollView.addConstraintsProgrammatically
			.pinToSuperSafeArea()
		
		scrollView.addSubview(contentView)
		contentView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .width, .equal, to: .width, of: scrollView)
		
		let blueView = UIView()
		blueView.backgroundColor = UIColor(red: 0.946, green: 0.973, blue: 0.988, alpha: 1)
		contentView.addSubview(blueView)

		let spacing: CGFloat = 30.0
				
		contentView.addSubview(topImage)
		contentView.addSubview(roundedView)
		contentView.addArrangedSubview(headingWhatIsThisProject)
		contentView.addArrangedSubview(textWhatIsThisProject)
		contentView.setCustomSpacing(spacing, after: textWhatIsThisProject)
		contentView.addArrangedSubview(headingHowMapWorks)
		contentView.addArrangedSubview(textHowMapWorks)
		contentView.addArrangedSubview(greenCard)
		contentView.addArrangedSubview(yellowCard)
		contentView.addArrangedSubview(redCard)
		contentView.setCustomSpacing(spacing, after: redCard)
		contentView.addArrangedSubview(headingParticipate)
		contentView.addArrangedSubview(womanImage)
		contentView.addArrangedSubview(textParticipate)
		contentView.setCustomSpacing(spacing, after: textParticipate)
		contentView.addArrangedSubview(headingWhyNeedMap)
		contentView.addArrangedSubview(whyNeedMap)
		contentView.addArrangedSubview(whyNeedMap2)
		contentView.addArrangedSubview(whyNeedMap3)
		contentView.setCustomSpacing(spacing, after: whyNeedMap3)
		contentView.addArrangedSubview(headingProjectUsefull)
		contentView.addArrangedSubview(textProjectUsefull)
		contentView.setCustomSpacing(spacing, after: textProjectUsefull)
		
		contentView.addArrangedSubview(headingPartners)
		let partnerImages = UIStackView()
		partnerImages.axis = .horizontal
		partnerImages.distribution = .equalCentering
		partnerImages.addArrangedSubview(partnerImage1)
		partnerImages.addArrangedSubview(partnerImage2)
		partnerImages.addArrangedSubview(partnerImage3)
		contentView.addArrangedSubview(partnerImages)
		contentView.addArrangedSubview(textPartners)
		
		contentView.setCustomSpacing(spacing, after: textPartners)
		
		contentView.addArrangedSubview(headingFinancing)
		let financingImages = UIStackView()
		financingImages.axis = .horizontal
		financingImages.spacing = 8
		financingImages.distribution = .equalCentering
		financingImages.addArrangedSubview(financeImage1)
		financingImages.addArrangedSubview(financeImage2)
		contentView.addArrangedSubview(financingImages)
		contentView.addArrangedSubview(textFinancing)
		
		roundedView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pin(my: .bottom, andOf: headingWhatIsThisProject)
			.pin(my: .top, andOf: headingWhatIsThisProject, plus: -21)
		topImage.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.top)
			.pin(my: .bottom, to: .top, of: headingWhatIsThisProject)
		
		blueView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pin(my: .top, andOf: headingParticipate, plus: -15)
			.pin(my: .bottom, andOf: textParticipate, plus: 21)
	}
	
}

fileprivate typealias About = TextAroundImageView.Props

class TextAroundImageView: UIView {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let imageView = UIImageView()
	let textView = UITextView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		textView.font = .systemFont(ofSize: 14)
		textView.textContainer.lineFragmentPadding = 0
		textView.textContainerInset = .zero
		
		addSubview(textView)
		addSubview(imageView)

		height = textView.addConstraintsProgrammatically
			.pinToSuper()
			.set(my: .height, to: 10)
			.constraint
		
		imageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.set(my: .height, to: 128)
			.set(my: .width, to: 128)
	}
	
	var height: NSLayoutConstraint?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let frame = imageView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8))
		let imagePath = UIBezierPath(rect: frame)
		textView.textContainer.exclusionPaths = [imagePath]
		height?.constant = textView.contentSize.height
	}
	
	var props: Props! {
		didSet {
			textView.text = props.text
			imageView.image = UIImage(named: props.image)
		}
	}
	
	struct Props {
		var image: String
		var text: String
	}
	
}

fileprivate typealias Card = AboutCardView.Props

class AboutCardView: UIView {
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let imageView = UIImageView()
	let titleLabel = UILabel()
	let textLabel = UILabel()
	let shadowView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		layer.cornerRadius = 2
		shadowView.backgroundColor = .white
		shadowView.layer.cornerRadius = 2
		shadowView.layer.shadowColor = UIColor(red: 0.482, green: 0.584, blue: 0.655, alpha: 0.15).cgColor
		shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
		shadowView.layer.shadowOpacity = 1.0
		shadowView.layer.shadowRadius = 2.0
		
		addSubview(shadowView)
		shadowView.addConstraintsProgrammatically
			.pinToSuper()
		
		addSubview(imageView)
		addSubview(titleLabel)
		addSubview(textLabel)

		titleLabel.numberOfLines = 0
		textLabel.numberOfLines = 0
		
		titleLabel.decorate(with: Style.systemFont(size: 14, weight: .bold))
		textLabel.decorate(with: Style.systemFont(size: 14))
		
		imageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 16)
			.pinEdgeToSupers(.leading, plus: 16)
			.set(my: .height, to: 32)
			.set(my: .width, to: 32)
		titleLabel.addConstraintsProgrammatically
			.pin(my: .leading, to: .trailing, of: imageView, plus: 8)
			.pin(my: .top, andOf: imageView)
			.pin(my: .bottom, andOf: imageView)
			.pinEdgeToSupers(.trailing, plus: -16)
		textLabel.addConstraintsProgrammatically
			.pin(my: .leading, andOf: imageView)
			.pin(my: .top, to: .bottom, of: imageView, plus: 8)
			.pinEdgeToSupers(.trailing, plus: -16)
			.pinEdgeToSupers(.bottom, plus: -16)
	}
	
	var props: Props! {
		didSet {
			imageView.image = UIImage(named: props.image)
			titleLabel.text = props.title
			textLabel.text = props.text
		}
	}
	
	struct Props {
		let image: String
		let title: String
		let text: String
	}
	
}
