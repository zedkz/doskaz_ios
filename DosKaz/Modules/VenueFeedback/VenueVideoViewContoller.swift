//
//  VenueVideoViewContoller.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 5/28/20.
//  Copyright © 2020 zed. All rights reserved.
//

import WebKit
import UIKit

typealias YoutubeVideo = String

class VenueVideoViewContoller: UIViewController, UITableViewDelegate{
	
	let titleLb = UILabel()
	let tableView = ContentSizedTableView()
	var dataSource: UTableViewDataSource<VenueVideoCell>!
	var videos = [YoutubeVideo]()
	
	func initWith(with videos: [YoutubeVideo]) {
		self.videos = videos
	}
	
	private func update(with videos: [YoutubeVideo]) {
		let cellsProps = videos.map { VenueVideoCell.Props(video: $0) }
		dataSource.cellsProps = cellsProps
		tableView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	
		titleLb.text = l10n(.video).uppercased()
		titleLb.decorate(with: Style.systemFont(size: 14, weight: .bold))
		
		dataSource = UTableViewDataSource(tableView)
		tableView.dataSource = dataSource
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.delegate = self
		
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
		
		
		update(with: videos)
		
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selected = videos[indexPath.row]
		let wv = WebViewController()
		wv.link = selected
		let nav = UINavigationController(rootViewController: wv)
		present(nav, animated: true, completion: nil)
	}
	
}

class WebViewController: UIViewController {
	
	let webView = WKWebView()
	
	var link = ""
	
	override func loadView() {
		self.view = webView
	}
	
	@objc func close() {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: l10n(.close), style: .done,
			target: self,
			action: #selector(close)
		)
		
		if let url = URL(string: link) {
			let request = URLRequest(url: url)
			webView.load(request)
		}
	}
	
}

extension String {
	var youtubeID: String? {
		let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
		
		let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		let range = NSRange(location: 0, length: count)
		
		guard let result = regex?.firstMatch(in: self, range: range) else {
			return nil
		}
		
		return (self as NSString).substring(with: result.range)
	}
	
}

class VenueVideoCell: UITableViewCell, Updatable {
	
	let previewImage = UIImageView()
	let playButton = UIImageView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
	
		playButton.image = UIImage(named: "youtube_play")
		
		previewImage.backgroundColor = UIColor.purple.withAlphaComponent(0.05)
		previewImage.layer.cornerRadius = 2
		previewImage.clipsToBounds = true
		
		contentView.addSubview(previewImage)
		contentView.addSubview(playButton)
		
		previewImage.addConstraintsProgrammatically
			.pinToSuper(inset: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
			.set(my: .height, to: 184)
		
		playButton.addConstraintsProgrammatically
			.pinEdgeToSupers(.verticalCenter)
			.pinEdgeToSupers(.horizontalCenter)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var props: Props! {
		didSet {
			if let videoID = props.video.youtubeID {
				let url = URL(string: "http://img.youtube.com/vi/\(videoID)/0.jpg")
				previewImage.kf.indicatorType = .activity
				previewImage.kf.setImage(
					with: url,
					options: [
						.scaleFactor(UIScreen.main.scale),
						.transition(.fade(1)),
						.cacheOriginalImage
				])
			}
		}
	}
	
	struct Props {
		var video: YoutubeVideo
	}
	
}

