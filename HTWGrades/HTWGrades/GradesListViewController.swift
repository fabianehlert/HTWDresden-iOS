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
	
    var grades = [[Grade]]()
    
    var highlightedIndexPath: NSIndexPath?
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        var Average: Double = 0
        var Index: Double = 0
		
		tableView?.dataSource = self
        tableView?.delegate = self
        
        let nib = UINib(nibName: "GradeExtendedCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "extended")
        let nib2 = UINib(nibName: "GradeCompactCell", bundle: nil)
        tableView?.registerNib(nib2, forCellReuseIdentifier: "compact")
		
		let model = GradesModel()
		model.start {
			grades in
            self.grades = grades.map { $0.1 }
            Average += model.getAverge(self.grades)
            Index += 1
            Average /= Index
            self.title = "Gesamt: Ø " + String(format: "%.2f", Average)
            self.tableView?.reloadData()
		}
        
	}
}

extension GradesListViewController: UITableViewDataSource, UITableViewDelegate {
	
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return grades.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return grades[section].first?.semester
    }
    
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return grades[section].count
	}
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return highlightedIndexPath == indexPath ? 200 : 50
    }
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
	
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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




























