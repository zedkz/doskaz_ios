//
//  VenueHistoryViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/28/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class VenueHistoryViewController: UIViewController {
	
	let titleLb = UILabel()
	let tableView = ContentSizedTableView()
	var dataSource: UTableViewDataSource<VenueHistoryCell>!
	var historys = [History]()
	
	func initWith(with historys: [History]) {
		self.historys = historys
	}
	
	private func update(with historys: [History]) {
		var testHistorys = historys
		testHistorys.append(History(name: "Алдияр Тулебаев", date: "12 августа", data: DataClass(type: "добавил 2 фотографии")))
		testHistorys.append(History(name: "Алдияр Тулебаев", date: "24 августа", data: DataClass(type: "верифицировал описание объекта")))
		testHistorys.append(History(name: "Алия Серикпаева", date: "13 августа", data: DataClass(type: "прокомментировала объект")))
		
		let cellsProps = testHistorys.map { VenueHistoryCell.Props(history: $0) }
		dataSource.cellsProps = cellsProps
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleLb.text = l10n(.history).uppercased()
		titleLb.decorate(with: Style.systemFont(size: 14, weight: .bold))
		
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.allowsSelection = false
		tableView.isUserInteractionEnabled = false
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		
		view.addSubview(titleLb)
		view.addSubview(tableView)
		
		titleLb.addConstraintsProgrammatically
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.top, plus: 16)
		
		tableView.addConstraintsProgrammatically
			.pin(my: .top, to: .bottom, of: titleLb, plus: 10)
			.pinEdgeToSupersSafe(.trailing, plus: -16)
			.pinEdgeToSupersSafe(.leading, plus: 16)
			.pinEdgeToSupersSafe(.bottom, plus: -16)
			.set(my: .height, .greaterThanOrEqual, to: 90)
		
		
		update(with: historys)
		
	}
	
}


class VenueHistoryCell: UITableViewCell, Updatable {
	
	let dateLb = UILabel()
	let textLb = UILabel()
	
	var stack: UIStackView = {
		let s = UIStackView()
		s.axis = .vertical
		s.spacing = 4
		return s
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		
		
		dateLb.decorate(with: Style.systemFont(size: 12))
		dateLb.textColor = .gray
		textLb.numberOfLines = 0
		
		contentView.addSubview(stack)
		stack.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
		
		
		stack.addArrangedSubview(dateLb)
		stack.addArrangedSubview(textLb)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var props: Props! {
		didSet {
			let history = props.history
			
			dateLb.text = history.date
			
			let name = history.name
			let atrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]
			let atrName = NSMutableAttributedString(string: name, attributes: atrs)
			
			let atrsForType = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
			let atrType = NSAttributedString(string: " " + history.data.type, attributes: atrsForType)
			
			atrName.append(atrType)
			textLb.attributedText = atrName
		}
	}
	
	struct Props {
		var history: History
	}
	
}
