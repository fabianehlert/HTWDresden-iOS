//
//  NPMainTVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 29.10.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit
import CoreData

internal let COURSES_URL = NSURL(string: "https://wwwqis.htw-dresden.de/appservice/getcourses")!
internal let GRADES_URL = NSURL(string: "https://wwwqis.htw-dresden.de/appservice/getgrades")!

class NPMainTVC: UITableViewController {
    
    var model: NPMainModel!

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SNUMMER = "s68311"
        RZLOGIN = "HD5rdf92"
        
        löscheAlleNotenVonUser()
        
        model = NPMainModel()
        model.starte {
            self.tableView.reloadData()
        }
    }
    
    func löscheAlleNotenVonUser() {
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "Note")
        request.predicate = NSPredicate(format: "user = %@", user)
        let array = context.executeFetchRequest(request, error: nil) as [Note]
        for note in array {
            context.deleteObject(note)
        }
        context.save(nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsIn(section: section)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.semesterNameFor(section: section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let note = model.noteAt(indexPath: indexPath)!
        cell.textLabel?.text = note.name

        return cell
    }


}
