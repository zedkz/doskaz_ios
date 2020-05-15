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

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		navigationItem.title = l10n(.more)
		
		commands = [
			Command {
				
			},
			Command {
				
			},
			Command {
				self.present(CategoryPickerModuleConfigurator().assembleModule())
			},
			Command {
				self.present(BigFormBuilder().assembleModule())
			},
			
		]
		
		tableView.tableFooterView = UIView()
		
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.delegate = self
		
		let models = [
			SubtitleCell.Props(title: "О проекте"),
			SubtitleCell.Props(title: "Контакты"),
			SubtitleCell.Props(title: "Категория пользователя"),
			SubtitleCell.Props(title: "Язык", subTitle: "Русский"),
		]
		dataSource.cellsProps = models
		tableView.reloadData()
	
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		commands[indexPath.row].perform()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}

}

class SubtitleCell: UITableViewCell, Updatable {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .value1, reuseIdentifier: reuseIdentifier)
		accessoryView = UIImageView(image: UIImage(named: "chevron_right_passive"))
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(named: "CategoryPickerSelectedCell")
		selectedBackgroundView = backgroundView
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
