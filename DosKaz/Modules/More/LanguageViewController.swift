//
//  LanguageViewController.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/15/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class UpdatableCell: UITableViewCell, Updatable {
	struct Props {
		var title: String
		var isChecked: Bool
	}
	var props: Props! {
		didSet {
			textLabel?.text = props.title
			if props.isChecked {
				accessoryView = UIImageView(image: UIImage(named: "check_in_form"))
			} else {
				accessoryView = nil
			}
		}
	}
}

class LanguageViewController: TableViewController, UITableViewDelegate {
	
	var dataSource: UTableViewDataSource<UpdatableCell>!

	var models: [UpdatableCell.Props] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		tableView.tableFooterView = UIView()
		dataSource = UTableViewDataSource<UpdatableCell>(tableView) { cell in
			cell.selectionStyle = .none
		}
		tableView.dataSource = dataSource
		tableView.delegate = self
		
		var isKazakh = false
		var isRussian = false
		
		switch AppSettings.language {
		case .kazakh:
			isKazakh = true
			isRussian = false
		case .russian:
			isKazakh = false
			isRussian = true
		case nil:
			isKazakh = false
			isRussian = false
		}
		
		models = [
			.init(title: "Қазақша", isChecked: isKazakh),
			.init(title: "Русский", isChecked: isRussian)
		]
		
		dataSource.cellsProps = models
		tableView.reloadData()
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		models[indexPath.row].isChecked.toggle()
		dataSource.cellsProps = models
		tableView.reloadData()
		tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
		
		if indexPath.row == 0 {
			AppSettings.language = .kazakh
		} else {
			AppSettings.language = .russian
		}
		
		guard let keyWindow = UIApplication.shared.keyWindow else { return }
		keyWindow.rootViewController = MainTabBarViewController()
		
		if let tabViewController = keyWindow.rootViewController as? MainTabBarViewController {
			UIView.transition(
				with: keyWindow, duration: 0.2,
				options: .transitionFlipFromLeft,
				animations: { tabViewController.selectedIndex = 4 },
				completion: nil
			)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
	
	
}
