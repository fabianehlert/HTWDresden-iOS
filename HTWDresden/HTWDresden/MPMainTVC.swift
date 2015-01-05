//
//  MPMainTVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 27.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MPMainTVC: UITableViewController {

    var model: MPMainModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CURR_MENSA == nil {
            CURR_MENSA = "Mensa Reichenbachstraße"
        }

        // TODO: - Speisen laden
        model = MPMainModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        title = CURR_MENSA
        model.start() {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        model.refresh({
            self.tableView.reloadData()
            }, end: {
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsInSection(section)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MPMainCell", forIndexPath: indexPath) as MPMainCell

        cell.speise = model.speiseForIndexPath(indexPath)
        
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showList" {
            (segue.destinationViewController as MPListTVC).mensen = model.mensenTitel
        }
    }
    

}
