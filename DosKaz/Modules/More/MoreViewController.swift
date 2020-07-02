//
//  MoreViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import SharedCodeFramework

class MoreViewController: TableViewController, UITableViewDelegate {
	
	var dataSource: UTableViewDataSource<SubtitleCell>!
	
	var commands = [Command]()
	
	func present(_ viewController: UIViewController) {
		navigationController?.pushViewController(viewController, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateTable()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		navigationItem.title = l10n(.more)
		
		commands = [
			Command { [weak self] in
				self?.present(AboutProjectViewController())
			},
			Command { [weak self] in
				self?.present(ContactsViewController())
			},
			Command { [weak self] in
				let categoryPicker = CategoryPickerModuleConfigurator().assembleModule()
				categoryPicker.output.initView(with: .settings)
				self?.present(categoryPicker)
			},
			Command { [weak self] in
				self?.present(LanguageViewController())
			},
			
		]
		
		tableView.tableFooterView = UIView()
		
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.delegate = self
	}
	
	private func updateTable() {
		let handicaps = DisabilityCategories().load()
		let chosenCategory = AppSettings.disabilitiesCategory
		let disabilityTitle = handicaps.first { $0.key == chosenCategory?.keys.first }?.title
		
		let models = [
			SubtitleCell.Props(title: l10n(.aboutProject)),
			SubtitleCell.Props(title: l10n(.contacts)),
			SubtitleCell.Props(title: l10n(.categoryOfUser), subTitle: disabilityTitle),
			SubtitleCell.Props(title: l10n(.language), subTitle: "Русский"),
		]
		dataSource.cellsProps = models
		tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		commands[indexPath.row].perform()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 2 {
			return UITableView.automaticDimension
		} else {
			return 56
		}
	}

}

class SubtitleCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		accessoryView = UIImageView(image: UIImage(named: "chevron_right_passive"))
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(named: "CategoryPickerSelectedCell")
		selectedBackgroundView = backgroundView
		detailTextLabel?.textColor =  UIColor(named: "SelectedTabbarTintColor")
		detailTextLabel?.numberOfLines = 0
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			detailTextLabel?.text = props.subTitle
		}
	}
	
	struct Props {
		let title: String
		var subTitle: String?
	}

}
