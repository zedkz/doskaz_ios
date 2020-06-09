//
//  ProfileView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/18/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework
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
		taskTitleLabel.text = l10n(.currentTask)

		
		//mock data
		title.text = "–"
		statusTitle.text = l10n(.helpSomebody)
		levelProgressLabel.text = "0/0"
		levelLabel.text = "0 \(l10n(.level))"
		levelProgress.setProgress(0.3, animated: true)
		levelsStats.text = "0 \(l10n(.ofObjects))     0 \(l10n(.ofInvestigations))"
		
		taskLabel.text = "–"
		taskProgress.setProgress(0.3, animated: true)
		taskProgressLabel.text = "0/0"
		avatarImageView.image = UIImage(named: "avatar_placeholder")
		
		//MARK: - Configure style
		title.decorate(with: Style.systemFont(size: 18, weight: .semibold))
		statusTitle.decorate(with: Style.systemFont(size: 14))
		avatarImageView.layer.cornerRadius = 80/2
		avatarImageView.clipsToBounds = true
		avatarImageView.layer.borderWidth = 2
		avatarImageView.layer.borderColor = UIColor(named: "AvatarBorderColor")?.cgColor
		avatarImageView.backgroundColor = UIColor.white
		
		editButton.setTitle(l10n(.edit), for: .normal)
		editButton.decorate(with:
			Style.backgroundColor(color: UIColor(named: "VerifyInfoButton")),
			{ button in
				button.layer.cornerRadius = 2
				button.clipsToBounds = true
			}
		)
		
		editButton.didTouchUpInside = { [weak self] in
			self?.props?.onEdit.perform()
		}
		
		func style(topLabel: UILabel, leftLabel: UILabel, bottomLabel: UILabel) {
			topLabel.decorate(with: Style.systemFont(size: 14, weight: .bold))
			bottomLabel.decorate(with: Style.systemFont(size: 12))
			leftLabel.decorate(with: Style.systemFont(size: 10), { label in
				label.textColor = .gray
			})
		}
		
		style(topLabel: levelLabel, leftLabel: levelProgressLabel, bottomLabel: levelsStats)
		style(topLabel: taskTitleLabel, leftLabel: taskProgressLabel, bottomLabel: taskLabel)
		line.backgroundColor = UIColor(named: "UnselectedTabbarTintColor")?.withAlphaComponent(0.2)
		
		//MARK: - Configure behavior
		//MARK: - Layout
		addSubview(mainInfoContainer)
		addSubview(editButton)
		addSubview(levelsContainer)
		addSubview(taskContainer)
		addSubview(line)

		let space: CGFloat = 16
		mainInfoContainer.addConstraintsProgrammatically
			.pinEdgeToSupers(.top, plus: space)
			.pinEdgeToSupers(.leading, plus: space)
			.pinEdgeToSupers(.trailing, plus: -space)
			.pin(my: .bottom, to: .top, of: editButton, plus: -16)

		editButton.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: space)
			.pinEdgeToSupers(.trailing, plus: -space)
			.pin(my: .bottom, to: .top, of: levelsContainer, plus: -25)

		levelsContainer.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: space)
			.pinEdgeToSupers(.trailing, plus: -space)
			.pin(my: .bottom, to: .top, of: line, plus: -16)
		
		line.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: space)
			.pinEdgeToSupers(.trailing, plus: -space)
			.set(my: .height, to: 1)
			.pin(my: .bottom, to: .top, of: taskContainer, plus: -16)

		taskContainer.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: space)
			.pinEdgeToSupers(.trailing, plus: -space)
			.pinEdgeToSupers(.bottom, plus: -26)
		
		mainInfoContainer.addSubview(avatarImageView)
		mainInfoContainer.addSubview(title)
		mainInfoContainer.addSubview(statusTitle)
		
		mainInfoContainer.addConstraintsProgrammatically
			.set(my: .height, .greaterThanOrEqual, to: 80)
		
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
			.pin(my: .top, to: .bottom, of: title, plus: 4)
			.pinEdgeToSupers(.trailing)
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
	
	let line = UIView()
	
	//4
	let taskContainer = UIView()
	let taskTitleLabel = UILabel()
	let taskProgress = UIProgressView(progressViewStyle: .default)
	let taskProgressLabel = UILabel()
	let taskLabel = UILabel()
	
	var props: Props! {
		didSet {
			let profile = props.profile
			title.text = "\(profile.firstName ?? "–") \(profile.middleName ?? "–") \(profile.lastName ?? "–")"
			statusTitle.text = profile.status ?? "–"
			let level = profile.level
			levelLabel.text = String(level.current) + " \(l10n(.level))"
			levelProgressLabel.text = "\(level.currentPoints)/\(level.nextLevelThreshold)"
			let progress = Float(level.currentPoints) / Float(level.nextLevelThreshold)
			levelProgress.setProgress(progress, animated: true)

			let task = profile.currentTask
			levelsStats.text = "\(profile.stats.objects) \(l10n(.ofObjects))     \(profile.stats.complaints) \(l10n(.ofInvestigations))"
			
			taskLabel.text = task.title
			taskProgressLabel.text = "\(task.progress)/\(task.pointsReward)"
			
			let tp = Float(task.progress) / Float(task.pointsReward)
			taskProgress.setProgress(tp, animated: true)
			
			

		}
	}
	
	//MARK: - Sub types
	
	struct Props {
		var profile: Profile
		var onEdit: Command = .nop
	}
	
	//MARK: - Private methods
	
	private func horStack(progressView: UIProgressView, label: UIView) -> UIStackView {
		let s = UIStackView()
		s.axis = .horizontal
		s.alignment = .center
		s.spacing = 0
		progressView.addConstraintsProgrammatically
			.set(my: .width, to: 80)
			.set(my: .height, to: 3)
		progressView.layer.cornerRadius = 3/2
		progressView.clipsToBounds = true
		progressView.trackTintColor = UIColor(named: "UnselectedTabbarTintColor")?.withAlphaComponent(0.3)
		s.addArrangedSubview(progressView)
		s.addArrangedSubview(label)
		label.addConstraintsProgrammatically
			.set(my: .width, .greaterThanOrEqual, to: 10)
			.set(my: .width, .lessThanOrEqual, to: 34)
		return s
	}
	
	private func put(in container: UIView, topLabel: UILabel, progressView: UIProgressView, progressLabel: UILabel, bottomLabel: UILabel) {
		container.addSubview(topLabel)
		progressLabel.textAlignment = .right
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
	
}

