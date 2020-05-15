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
				accessoryView = UIImageView(image: UIImage(named: "confirm_button"))
			} else {
				accessoryView = nil
			}
		}
	}
}

class LanguageViewController: TableViewController, UITableViewDelegate {
	
	var dataSource: UTableViewDataSource<UpdatableCell>!

	var models: [UpdatableCell.Props] = [
		.init(title: "Kazakh", isChecked: false),
		.init(title: "Russian", isChecked: true)
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		tableView.tableFooterView = UIView()
		dataSource = UTableViewDataSource<UpdatableCell>(tableView) { cell in
			cell.selectionStyle = .none
		}
		tableView.dataSource = dataSource
		tableView.delegate = self
		
		dataSource.cellsProps = models
		tableView.reloadData()
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		models[indexPath.row].isChecked.toggle()
		dataSource.cellsProps = models
		tableView.reloadData()
		tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
		navigationController?.popViewController(animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
	
	
}
