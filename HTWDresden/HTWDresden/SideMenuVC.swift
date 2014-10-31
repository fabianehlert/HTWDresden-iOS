//
//  SideMenuVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 30.10.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = ["Stundenplan", "Noten", "Mensa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifier.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.row]) as UITableViewCell
        
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.isKindOfClass(SWRevealViewControllerSegue) {
            let swSegue = segue as SWRevealViewControllerSegue
            
            swSegue.performBlock = {
                rvc_segue, svc, dvc in
                let navController = self.revealViewController().frontViewController as UINavigationController
                navController.setViewControllers([dvc], animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPositionLeft, animated: true)
            }
        }
        
    }

}
