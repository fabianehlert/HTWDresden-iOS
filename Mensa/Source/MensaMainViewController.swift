//
//  MensaMainViewController.swift
//  Pods
//
//  Created by Benjamin Herzog on 04/03/16.
//
//

import UIKit
import Core

let getMensa = "http://www.studentenwerk-dresden.de/feeds/speiseplan.rss"

class MensaMainViewController: Core.ViewController {

	let identifier = "cell"

	var tableView = UITableView()
	var mensaData: [(name: String, meals: [MensaData])] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.frame = view.bounds
		tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		tableView.delegate = self
		tableView.dataSource = self

		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)

		view.addSubview(tableView)

		let p = Parser(strPath: getMensa)
		mensaData = p.loadData().map { ($0.0, $0.1) }.sort { $0.0 < $1.0 }
	}
}

extension MensaMainViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mensaData.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(identifier)!
		cell.textLabel?.text = mensaData[indexPath.row].name
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let controller = MealMainViewController()
		controller.meals = mensaData[indexPath.row].meals
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
