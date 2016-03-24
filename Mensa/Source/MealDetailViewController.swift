//
//  MealDetailViewController.swift
//  Pods
//
//  Created by Daniel Martin on 24.03.16.
//
//

class MealDetailViewController: UIViewController {
    var tableView = UITableView()
    var data: [String] = ["#Bild#"]
    //var imgImage: UIImage = UIImage(named: "")!
    //var bLoaded: Bool = false
    
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
        data.append(mensaData[selectedMeal].strTitle)
        data.append(mensaData[selectedMeal].strDescription)
        data.append(mensaData[selectedMeal].strCost)
    }
}

extension MealDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        if (indexPath.row == 0) {
            // Load Pic
            loadImageAsync("https://upload.wikimedia.org/wikipedia/commons/0/01/Bill_Gates_July_2014.jpg") { image, error in
                    cell.imageView?.image = image
            }
        }
        else {
            cell.textLabel?.text = self.data[indexPath.row]
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImageAsync(stringURL: NSString, completion: (UIImage!, NSError!) -> ()) {
        let url = NSURL(string: stringURL as String)
        let requestedURL = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(requestedURL, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            
            if error != nil {
                completion(nil, error)
            } else {
                completion(UIImage(data: data!), nil)
            }
        }
    }
}