//
//  DetailViewContoller.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 6/10/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

class DetailViewContoller: TableViewController {
	
	var venue: DoskazVenue!
	
	var zones: Zones { venue.attributes.zones	}
	
	private var dataSource: SectionedTableViewDataSource!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = l10n(.detailInfo)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "x_in_form"), style: .done,
			target: self,
			action: #selector(close)
		)
		configureTableview()
	}
	
	private func configureTableview() {
		tableView.register(cellClass: CommentCell.self)
		
		func items(for zone: [String: FormValue]) -> [CellConfiguratorType] {
			zone.map {
				CellConfigurator<CommentCell>(props: CommentCell.Props(title: $0, subTitle: $1.description))
			}
		}
		
		dataSource = SectionedTableViewDataSource(dataSources: [
			FormTableViewDataSource(l10n(.parking), items(for: zones.parking)),
			FormTableViewDataSource(l10n(.entrance), items(for: zones.entrance1)),
			FormTableViewDataSource(l10n(.movement), items(for: zones.movement)),
			FormTableViewDataSource(l10n(.service), items(for: zones.service)),
			FormTableViewDataSource(l10n(.toilet), items(for: zones.toilet)),
			FormTableViewDataSource(l10n(.navigation), items(for: zones.navigation)),
			FormTableViewDataSource(l10n(.serviceAccessibility), items(for: zones.serviceAccessibility))
		])
		
		tableView.dataSource = dataSource
		tableView.reloadData()
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
	
}
