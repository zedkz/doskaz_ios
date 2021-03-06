//
//  BlogCell.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit
import Kingfisher

class BlogCell: UITableViewCell, Updatable {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//MARK: - Configure constant data
		titleLabel.numberOfLines = 0
		content.numberOfLines = 3
		
		
		//MARK: - Configure style
		var random: UIColor {
			return UIColor(
				red: .random(in: 0...1),
				green: .random(in: 0...1),
				blue: .random(in: 0...1),
				alpha: 1.0
			)
		}
		picture.backgroundColor = random
		picture.layer.cornerRadius = 2
		picture.clipsToBounds = true
		
		titleLabel.decorate(with: Style.systemFont(size: 16, weight: .bold))
		content.decorate(with: Style.systemFont(size: 12))
		lastLineLabel.decorate(with: Style.systemFont(size: 10), { label in
			label.textColor = UIColor(named: "UnselectedTabbarTintColor")
		})

		
		//MARK: - Configure behavior
		//MARK: - Layout
		contentView.addSubview(container)
		
		container.addConstraintsProgrammatically
			.pinToSuper()
		
		container.addArrangedSubview(titleLabel)
		container.addArrangedSubview(picture)
		container.addArrangedSubview(content)
		container.addArrangedSubview(lastLineLabel)
		
		picture.addConstraintsProgrammatically
			.set(my: .height, to: 184)
			
	}
	
	//MARK: - Public properties and methods
	var props: Props! {
		didSet {
			titleLabel.text = props.title
			
			let attributedString = NSMutableAttributedString(string: props.content.removingHTMLEntities)
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineHeightMultiple = 1.68
			attributedString.addAttribute(
				NSAttributedString.Key.paragraphStyle,
				value:paragraphStyle,
				range:NSMakeRange(0, attributedString.length)
			)
			content.attributedText = attributedString
			
			lastLineLabel.text = props.lastLine
			
			let url = URL(string: Constants.mainURL + props.imageURL)
			picture.kf.indicatorType = .activity
			picture.kf.setImage(
				with: url,
				options: [
					.scaleFactor(UIScreen.main.scale),
					.transition(.fade(1)),
					.cacheOriginalImage
			])
		}
	}
	
	let container: UIStackView = {
		let s = UIStackView()
		s.axis = .vertical
		s.spacing = 10
		s.isLayoutMarginsRelativeArrangement = true
		s.layoutMargins = UIEdgeInsets(all: 24)
		return s
	}()
	
	let titleLabel = UILabel()
	let picture = UIImageView()
	let content = UILabel()
	let lastLineLabel = UILabel()
	
	//MARK: - Sub types
	struct Props {
		var item: Item? = nil
		var title: String
		var imageURL: String
		var content: String
		var lastLine: String
	}
	
}
