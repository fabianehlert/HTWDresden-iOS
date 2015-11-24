//
//  GradesListViewController.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 23/11/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit

class GradesListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView?
	
	var grades = [Grade]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Noten"
		
		tableView?.dataSource = self
		
		let nib = UINib(nibName: "GradeCell", bundle: nil)
		tableView?.registerNib(nib, forCellReuseIdentifier: "cell")
		
		let model = GradesModel()
		model.start {
			grades in
			
			print(grades)
			
			self.grades = grades
			self.tableView?.reloadData()
		}
	}
}

extension GradesListViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return grades.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GradeCell
		
		cell.grade = grades[indexPath.row]
		
		return cell
	}
	
}
