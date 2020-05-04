//
//  Eureka.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/3/20.
//  Copyright © 2020 zed. All rights reserved.
//

import Eureka

enum FF {

	static func section(with title: String, tag: String? = nil) -> Section {
		let initer = { (section: Section) in
			section.tag = tag
			var header = HeaderFooterView<UIView>(.callback({
				let view = UIView()
				let cell = UITableViewCell()
				view.addSubview(cell)
				cell.frame.size.height = 50
				cell.backgroundColor = .red
				cell.textLabel?.textColor = .white
				cell.textLabel?.text = section.header?.title
				return view
			}))
			header.height = {50}
			header.title = title
			section.header = header
		}
		
		let section = Section(title, initer)
		return section
	}
	
}
