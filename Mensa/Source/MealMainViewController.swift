//
//  MealMainViewController.swift
//  Pods
//
//  Created by Daniel Martin on 23.03.16.
//
//

class MealMainViewController: UIViewController {
    var tableView = UITableView()
    var data: [String] = []
    var mealData: [MensaData_t] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        GetMealData()
    }
    
    func GetMealData() {
        for iIndex in mensaData {
            if (iIndex.strMensa == mensaData[selectedMensa].strMensa) {
                mealData.append(iIndex)
                data.append(iIndex.strTitle)
            }
        }
    }
}

extension MealMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.data[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(mensaData[selectedMensa + indexPath.row].strTitle)
        print(mensaData[selectedMensa + indexPath.row].strDescription)
        print(mensaData[selectedMensa + indexPath.row].strCost)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}