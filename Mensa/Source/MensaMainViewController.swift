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

var mensaData: [MensaData_t] = []
var selectedMensa: Int = 0
var iUniqueMensen: [Int] = []

class MensaMainViewController: Core.ViewController {

    var tableView = UITableView()
    
    var data: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        let p: Parser = Parser.init(strPath: getMensa)
        mensaData = p.loadData()
        var bUnique = true
        for (var i = 0; i < mensaData.count; i += 1) {
            for index in data {
                if index == mensaData[i].strMensa {
                    bUnique = false
                }
                else {
                    bUnique = true
                }
            }
            if bUnique {
                data.append(mensaData[i].strMensa)
                iUniqueMensen.append(i)
            }
        }
    }
}

extension MensaMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.data[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(mensaData[iUniqueMensen[indexPath.row]].strMensa)
        selectedMensa = iUniqueMensen[indexPath.row]
        self.navigationController?.pushViewController(MealMainViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


