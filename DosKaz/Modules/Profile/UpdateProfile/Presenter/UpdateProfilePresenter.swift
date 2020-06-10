//
//  UpdateProfilePresenter.swift
//  UpdateProfile
//
//  Generated by ModuleGenerator.
//  Copyright © 2020-06-09 12:10:04 +0000 lobster.kz. All rights reserved.
//

import UIKit
import SharedCodeFramework

protocol UpdateProfileViewOutput {
	func viewIsReady()
	func initView(with profile: Profile)
}
		
class UpdateProfilePresenter: UpdateProfileViewOutput {
	
	weak var view: UpdateProfileViewInput!
	var interactor: UpdateProfileInteractorInput!
	var router: UpdateProfileRouterInput!
	
	func initView(with profile: Profile) {
		self.profile = PutProfile(
			firstName: nonNil(profile.firstName),
			lastName: nonNil(profile.lastName),
			middleName: nonNil(profile.middleName),
			email: nonNil(profile.email),
			status: nonNil(profile.status)
		)
	}
	
	func viewIsReady() {
		view.setupInitialState()
		configureFields()
		view.reloadData()
		view.onSave = Command { [weak self] in
			print("save")
		}
	}
	
	var profile: PutProfile?
	
	var isValidating = false
	
	private func shouldBeRed(_ value: String?) -> Bool {
		(value ?? "").isEmpty && self.isValidating
	}
	
	private func configureFields () {
		// Heading
		let editProfile = l10n(.editProfile)
		let atrs1 = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold) ]
		let part1 = NSAttributedString(string: editProfile, attributes: atrs1)
		
		let fillProfile = "\n" + l10n(.fillProfile) + "\n"
		let part2 = NSAttributedString(string: fillProfile)
		
		let text = NSMutableAttributedString()
		text.append(part1)
		text.append(part2)
		let _headline = TextCell.Props(title: text, isBlue: false)
		let headline = CellConfigurator<TextCell>(props: _headline)
		
		// Family name
		let _familyName = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(profile?.lastName),
			text: nonNil(profile?.lastName),
			title: l10n(.familyName),
			mode: .onlyTextField,
			onEditText: Text { [weak self] text in
				self?.profile?.lastName = text
				self?.configureFields()
			}
		)
		let familyName = CellConfigurator<TextFormCell>(props: _familyName)
		
		// Name
		let _name = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(profile?.firstName),
			text: nonNil(profile?.firstName),
			title: l10n(.firstName),
			mode: .onlyTextField,
			onEditText: Text { [weak self] text in
				self?.profile?.firstName = text
				self?.configureFields()
			}
		)
		let name = CellConfigurator<TextFormCell>(props: _name)
		
		// Middle name
		let _middleName = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(profile?.middleName),
			text: nonNil(profile?.middleName),
			title: l10n(.middleName),
			mode: .onlyTextField,
			onEditText: Text { [weak self] text in
				self?.profile?.middleName = text
				self?.configureFields()
			}
		)
		let middleName = CellConfigurator<TextFormCell>(props: _middleName)
		
		// Email
		let _email = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(profile?.email),
			text: nonNil(profile?.email),
			title: l10n(.email),
			mode: .onlyTextField,
			onEditText: Text { [weak self] text in
				self?.profile?.email = text
				self?.configureFields()
			}
		)
		let email = CellConfigurator<TextFormCell>(props: _email)
		
		// Status
		let _status = TextFormCell.Props(
			canShowRedAlert: shouldBeRed(profile?.status),
			text: nonNil(profile?.status),
			title: l10n(.status),
			mode: .onlyTextField,
			onEditText: Text { [weak self] text in
				self?.profile?.status = text
				self?.configureFields()
			}
		)
		let status = CellConfigurator<TextFormCell>(props: _status)
		
		let configurators: [CellConfiguratorType] = [
			headline,
			familyName,
			name,
			middleName,
			email,
			status
		]
		
		view.updateTable(with: configurators)
		
	}

}

// MARK: Interactor output protocol

protocol UpdateProfileInteractorOutput: class {

}

extension UpdateProfilePresenter: UpdateProfileInteractorOutput {

}
