//
//  VenueDescriptionView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 4/27/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class VenueDescriptionView: UIView {
	
	//MARK: -inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		configureConstantData()
		configureStyle()
		configureBehaviour()
		VenueDescriptionViewLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	// MARK: - Sub types
	
	struct Props {
		let venue: DoskazVenue
	}
	
	//MARK: - Public properties and methods
	
	var props: Props! {
		didSet {
			guard let props = props else { return }
			
			mainText.text  = props.venue.description
			venueStatus.text = props.venue.verificationStatus
		}
	}
	
	let title = UILabel()
	let mainText = UILabel()
	let detailInfo = Button(type: .system)
	let venueStatus = UILabel()
	let verifyInfo = Button(type: .system)
	let complain = Button(type: .system)
	
	//MARK: - Private
	
	private func configureConstantData() {
		title.text = l10n(.description)
		mainText.text = """
		Суши бар находится на первом этаже, входная группа выполнена на одном уровне с землёй,
		заезжать на коляске удобно и просторно. Есть парковка с двумя специально отведёнными местами
		для инвалидов. Пути движения по объекту достаточно просторны, можно проехать не мешая
		движению других. Возле кассовой стойки можно комфортно общаться с продавцом. Туалет с чашами генуя,
		не оборудован для людей, передвигающихся на колясках. Навигация представлена только в виде табличек
		на парковке, внутри помещения никаких специальных указателей нет.
		"""
		detailInfo.setTitle(l10n(.detailInfo), for: .normal)
		venueStatus.text = "Объект частично верифицирован"
		verifyInfo.setTitle(l10n(.verifyInfo), for: .normal)
		verifyInfo.setImage(UIImage(named: "confirm_button"), for: .normal)
		complain.setTitle(l10n(.complain), for: .normal)
		complain.setImage(UIImage(named: "complaint_button"), for: .normal)
	}
	
	private func configureStyle() {
		title.decorate(with: Style.systemFont(size: 14, weight: .bold))
		mainText.decorate(with: Style.multiline())
		detailInfo.decorate(with: Style.systemFont(size: 14))
		venueStatus.decorate(with: Style.systemFont(size: 12))
		
		verifyInfo.decorate(with:
			Style.corneredBorder(radius: 2, color: UIColor(named:"VerifyInfoButton")),
			Style.backgroundColor(color: UIColor(named: "VerifyInfoButton")),
			Style.commonButton
		)
		
		complain.decorate(with:
			Style.corneredBorder(radius: 2, color: UIColor.lightGray.withAlphaComponent(0.5)),
			Style.commonButton
		)
		
		let inset: CGFloat = 8
		complain.titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
		verifyInfo.titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
	}
	
	private func configureBehaviour() {
		
	}
	
}

struct VenueDescriptionViewLayout {
	weak var rv: VenueDescriptionView!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension VenueDescriptionViewLayout {
	
	func addSubviews() {
		rv.addSubview(rv.title)
		rv.addSubview(rv.mainText)
		rv.addSubview(rv.detailInfo)
		rv.addSubview(rv.venueStatus)
		rv.addSubview(rv.verifyInfo)
		rv.addSubview(rv.complain)
		
	}
	
	func addConstraints() {
		rv.title.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing, plus: -16)
			.pinEdgeToSupers(.leading, plus: 16)
			.pinEdgeToSupers(.top, plus: 16)
		
		rv.mainText.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: rv.title, plus: 8)
			.pinEdgeToSupers(.trailing, plus: -16)
			.pinEdgeToSupers(.leading, plus: 16)
		
		rv.detailInfo.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading, plus: 16)
			.pin(my: .top, to: .bottom, of: rv.mainText, plus: 8)
		
		rv.venueStatus.addConstraintsProgrammatically
			.pinEdgeToSupers(.trailing, plus: -16)
			.pinEdgeToSupers(.leading, plus: 16)
			.pin(my: .top, to: .bottom, of: rv.detailInfo, plus: 8)
	
		rv.verifyInfo.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.set(my: .width, .greaterThanOrEqual, to: .width, of: rv, times: 0.64)
			.set(my: .width, .lessThanOrEqual, to: .width, of: rv, times: 0.64)
			.pin(my: .top, to: .bottom, of: rv.venueStatus, plus: 22)
			.set(my: .height, to: 44)
		
		rv.complain.addConstraintsProgrammatically
			.pinEdgeToSupers(.horizontalCenter)
			.set(my: .width, .greaterThanOrEqual, to: .width, of: rv, times: 0.64)
			.set(my: .width, .lessThanOrEqual, to: .width, of: rv, times: 0.64)
			.pin(my: .top, to: .bottom, of: rv.verifyInfo, plus: 12)
			.pinEdgeToSupers(.bottom, plus: -30)
			.set(my: .height, .greaterThanOrEqual, to: 44)
		
	}
		
}


class TemplateView: UIView {
	
	//MARK: -inits
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		configureConstantData()
		configureStyle()
		configureBehaviour()
		TemplateViewLayout(rv: self).draw()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	//MARK: - Public properties and methods
	
	//MARK: - Private
	
	private func configureConstantData() {
		
	}
	
	private func configureStyle() {
		
	}
	
	private func configureBehaviour() {
		
	}
	
	// MARK: - Sub types
	
	
}

struct TemplateViewLayout {
	weak var rv: TemplateView!
	
	func draw() {
		addSubviews()
		addConstraints()
	}
}

extension TemplateViewLayout {
	
	func addSubviews() {
		
	}
	
	func addConstraints() {
		
	}
	
}
