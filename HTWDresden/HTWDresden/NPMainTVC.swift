//
//  NPMainTVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 29.10.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit
import CoreData

class NPMainTVC: UITableViewController {
    
    var model: NPMainModel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.enabled = false
        model = NPMainModel()
        model.starte {
            self.refreshButton.enabled = true
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        refreshButton.enabled = false
        model.refreshNoten {
            self.refreshButton.enabled = true
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsIn(section: section)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selected != indexPath {
            return 75
        }
        else {
            return 187
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.semesterNameFor(section: section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let note = model.noteAt(indexPath: indexPath)!
        
        if selected != indexPath {
            let cell = tableView.dequeueReusableCellWithIdentifier("Standard", forIndexPath: indexPath) as NPStandardMainTVCell
            
            cell.note = note
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Detail", forIndexPath: indexPath) as NPDetailMainTVCell
            
            cell.note = note
            
            return cell
        }
    }
    
    private var selected = NSIndexPath(forRow: -1, inSection: -1)
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selected.row >= 0 {
            let temp = selected
            selected = NSIndexPath(forRow: -1, inSection: -1)
            tableView.reloadRowsAtIndexPaths([temp], withRowAnimation: UITableViewRowAnimation.Fade)
            if temp == indexPath {
                return
            }
        }
        selected = indexPath
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }


}

























