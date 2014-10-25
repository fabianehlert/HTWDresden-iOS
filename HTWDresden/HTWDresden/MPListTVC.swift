//
//  MPListTVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 27.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MPListTVC: UITableViewController {
    
    var mensen: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        if mensen == nil || mensen.count == 0 {
            mensen = ["Keine Mensen verfügbar. Bitte hier tippen."]
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensen?.count ?? 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel.text = mensen[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CURR_MENSA = mensen[indexPath.row]
        if device() == .Pad {
            presentingViewController?.viewWillAppear(true)
        }
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
