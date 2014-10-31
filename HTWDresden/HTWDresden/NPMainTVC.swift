//
//  NPMainTVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 29.10.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

let kURL = NSURL(string: "http://www.benchr.de/Noten/GetGrade.json")!

class NPMainTVC: UITableViewController {
    
    var notenDaten = [[[String:String]]]()

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var sideBarButton = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Bordered, target: self.revealViewController(), action: Selector("revealToggle:"))
        navigationItem.leftBarButtonItem = sideBarButton
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let request = NSURLRequest(URL: kURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            if data == nil || error != nil {
                println("error")
                return
            }
            let tempDaten = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as [[String:String]]
            self.notenDaten = self.groupBySemester(daten: tempDaten)
            self.tableView.reloadData()
            
        }
        
    }
    
    func groupBySemester(#daten: [[String:String]]) -> [[[String:String]]] {
        var erg = [[[String:String]]]()
        var bekannteSemester = [String:Int]()
        
        for temp in daten {
            var tempCopy = temp
            tempCopy["Semester"] = semesterStringToSemester(string: tempCopy["Semester"]!)
            var semester = tempCopy["Semester"]!
            if bekannteSemester[semester] == nil {
                bekannteSemester[semester] = erg.count
                erg.append([[String:String]]())
            }
            erg[bekannteSemester[semester]!].append(tempCopy)
        }
        
        erg.sort {
            semester1, semester2 in
            return semester1[0]["Semester"]?.componentsSeparatedByString(" ")[1] > semester2[0]["Semester"]?.componentsSeparatedByString(" ")[1]
        }
        
        return erg
    }
    
    func semesterStringToSemester(#string: String) -> String? {
        if string.length != 5 { return nil }
        var erg: String
        var jahr = string.subString(0, length: 4)
        if string.subString(4, length: 1) == "1" {
            // Sommersemester
            erg = "Sommersemester \(jahr)"
        }
        else {
            // Wintersemester
            erg = "Wintersemester \(jahr)/\(jahr.toInt()!+1-2000)"
        }
        return erg
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return notenDaten.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notenDaten[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return notenDaten[section][0]["Semester"]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel.text = notenDaten[indexPath.section][indexPath.row]["PrTxt"]

        return cell
    }


}
