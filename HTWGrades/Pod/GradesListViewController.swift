//
//  GradesListViewController.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 23/11/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit
import Core

public class GradesListViewController: ViewController {

	var tableView = UITableView()

	var grades = [[Grade]]()

	var highlightedIndexPath: NSIndexPath?

	let model = GradesModel(settings: GradesModule.shared.settings)

	override public func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadData")
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "settings")

		tableView.frame = view.bounds
		tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		view.addSubview(tableView)

		tableView.dataSource = self
		tableView.delegate = self

		let nib = UINib(nibName: "GradeExtendedCell", bundle: NSBundle(forClass: GradeExtendedCell.self))
		tableView.registerNib(nib, forCellReuseIdentifier: "extended")
		let nib2 = UINib(nibName: "GradeCompactCell", bundle: NSBundle(forClass: GradeCompactCell.self))
		tableView.registerNib(nib2, forCellReuseIdentifier: "compact")

		reloadData()
	}

	func reloadData() {
		model.start {
			[unowned self] grades in
			self.grades = grades.map { $0.1 }
			self.title = "Gesamt: Ø " + String(format: "%.2f", GradesModel.getAverage(self.grades))
			self.tableView.reloadData()
		}
	}

	func settings() {
		let v = GradesSettingsController(router: self.router)
		v.settings = GradesModule.shared.settings
		v.delegate = self
        let n = v.wrapInNavigationController()
        n.modalPresentationStyle = .PageSheet
		presentViewController(n, animated: true, completion: nil)
//		navigationController?.pushViewController(v, animated: true)
	}
}

extension GradesListViewController: GradesSettingsControllerDelegate {
	func didUpdateValues() {
		reloadData()
	}
}

extension GradesListViewController: UITableViewDataSource, UITableViewDelegate {

	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return grades.count
	}

	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return grades[section].first?.semester
	}

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return grades[section].count
	}

	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return highlightedIndexPath == indexPath ? 200 : 50
	}

	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: GradeCell
		if indexPath == highlightedIndexPath {
			cell = tableView.dequeueReusableCellWithIdentifier("extended") as! GradeExtendedCell
		}
		else {
			cell = tableView.dequeueReusableCellWithIdentifier("compact") as! GradeCompactCell
		}

		cell.grade = grades[indexPath.section][indexPath.row]

		return cell
	}

	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		var indexPathsToHighlight = [NSIndexPath]()

		if indexPath == highlightedIndexPath {
			highlightedIndexPath = nil
			indexPathsToHighlight.append(indexPath)
		}
		else {
			if let oldHighlight = highlightedIndexPath {
				indexPathsToHighlight.append(oldHighlight)
			}
			highlightedIndexPath = indexPath
			indexPathsToHighlight.append(highlightedIndexPath!)
		}

		tableView.reloadRowsAtIndexPaths(indexPathsToHighlight, withRowAnimation: .Fade)
	}
}
