//
//  ProfileView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/18/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class ProfileView: UIView {
	
	//MARK: -inits
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		//MARK: - Configure constant data
		statusTitle.numberOfLines = 0
		title.numberOfLines = 0
		taskLabel.numberOfLines = 0
		
		//MARK: - Configure style
		//fake begin
		avatarImageView.backgroundColor = .purple
		title.backgroundColor = .yellow
		title.text = "kudaibergenov almas"
		statusTitle.text = "almos gino enis kero fnec kops lojf aesc twnc dofe alsk adsf asdf zxcv esld esfs lopf ersd erds fdtr gfbv jknm vbfg dfsd"
		levelProgressLabel.text = "34/56"
		levelLabel.text = "7 level"
		levelProgress.setProgress(0.3, animated: true)
		levelsStats.text = "18 объектов     5 проверок"
		levelsStats.backgroundColor = .systemRed
		
		taskLabel.text = "Добавьте 5 объектов в Северном промышленном районе"
		taskTitleLabel.text = "Текущее задание"
		taskProgress.setProgress(0.3, animated: true)
		taskProgressLabel.text = "3/4"
		taskLabel.backgroundColor = .systemRed
		//fake end
		
		editButton.setTitle(l10n(.edit), for: .normal)
		editButton.decorate(with:
			Style.backgroundColor(color: UIColor(named: "VerifyInfoButton")),
			{ button in
				button.layer.cornerRadius = 2
				button.clipsToBounds = true
			}
		)
		
		//MARK: - Configure behavior
		//MARK: - Layout
		addSubview(mainInfoContainer)
		addSubview(editButton)
		addSubview(levelsContainer)
		addSubview(taskContainer)

		mainInfoContainer.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: 10)
			.pinEdgeToSupers(.leading, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -10)
			.pin(my: .bottom, to: .top, of: editButton, plus: -16)

		editButton.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -10)
			.pin(my: .bottom, to: .top, of: levelsContainer, plus: -16)

		levelsContainer.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -10)
			.pin(my: .bottom, to: .top, of: taskContainer, plus: -16)

		taskContainer.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 10)
			.pinEdgeToSupers(.trailing, plus: -10)
			.pinEdgeToSupers(.bottom, plus: -10)
		
		mainInfoContainer.addSubview(avatarImageView)
		mainInfoContainer.addSubview(title)
		mainInfoContainer.addSubview(statusTitle)
		
		avatarImageView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.set(my: .width, to: 80)
			.set(my: .height, to: 80)
		title.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.trailing)
			.pin(my: .leading, to: .trailing, of: avatarImageView, plus: 10)
		statusTitle.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: title, plus: 8)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom)
			.pin(my: .leading, to: .trailing, of: avatarImageView, plus: 10)
		
		editButton.addConstraintsProgrammatically
			.set(my: .height, to: 40)
	
		put(
			in: levelsContainer,
			topLabel: levelLabel,
			progressView: levelProgress,
			progressLabel: levelProgressLabel,
			bottomLabel: levelsStats
		)
		
		put(
			in: taskContainer,
			topLabel: taskTitleLabel,
			progressView: taskProgress,
			progressLabel: taskProgressLabel,
			bottomLabel: taskLabel
		)

	}
	
	//MARK: - Public properties and methods
	//1
	let mainInfoContainer = UIView()
	let avatarImageView = UIImageView()
	let title = UILabel()
	let statusTitle = UILabel()

	//2
	let editButton = Button(type: .system)
	
	//3
	let levelsContainer = UIView()
	let levelLabel = UILabel()
	let levelProgressLabel = UILabel()
	let levelProgress = UIProgressView(progressViewStyle: .default)
	let levelsStats = UILabel()
	
	//4
	let taskContainer = UIView()
	let taskTitleLabel = UILabel()
	let taskProgress = UIProgressView(progressViewStyle: .default)
	let taskProgressLabel = UILabel()
	let taskLabel = UILabel()
	
	func horStack(progressView: UIProgressView, label: UIView) -> UIStackView {
		let s = UIStackView()
		s.axis = .horizontal
		s.alignment = .center
		s.spacing = 8
		progressView.addConstraintsProgrammatically
			.set(my: .width, to: 80)
			.set(my: .height, to: 3)
		progressView.layer.cornerRadius = 3/2
		progressView.clipsToBounds = true
		progressView.trackTintColor = UIColor(named: "UnselectedTabbarTintColor")?.withAlphaComponent(0.3)
		s.addArrangedSubview(progressView)
		s.addArrangedSubview(label)
		return s
	}
	
	func put(in container: UIView, topLabel: UILabel, progressView: UIProgressView, progressLabel: UILabel, bottomLabel: UILabel) {
		container.addSubview(topLabel)
		let levelProgressStack = horStack(progressView: progressView, label: progressLabel)
		container.addSubview(levelProgressStack)
		container.addSubview(bottomLabel)
		
		topLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.pinEdgeToSupers(.leading)
			.pin(my: .trailing, to: .leading, of: levelProgressStack)
		levelProgressStack.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.top)
		bottomLabel.addConstraintsProgrammatically
			.pinEdgeToSupers(.bottom)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.leading)
			.pin(my: .top, to: .bottom, of: topLabel, plus: 8)
	}
	
	//MARK: - Sub types
	
}

