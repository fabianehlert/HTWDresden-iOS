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

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.frame = view.bounds
		tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		tableView.delegate = self
		tableView.dataSource = self

		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

		view.addSubview(tableView)
	}
}

extension MealDetailViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.data.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell

		if (indexPath.row == 0) {
			// Load Pic
			loadImageAsync("https://upload.wikimedia.org/wikipedia/commons/0/01/Bill_Gates_July_2014.jpg") {
                image, error in
				cell.imageView?.image = image
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			}
		}
		else {
			cell.textLabel?.text = data[indexPath.row]
		}

		return cell
	}

	func loadImageAsync(stringURL: NSString, completion: (UIImage?, NSError?) -> ()) {
		let url = NSURL(string: stringURL as String)!

		NSURLSession.sharedSession().dataTaskWithURL(url) {
			data, response, error in

			if let error = error {
				completion(nil, error)
			} else {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(UIImage(data: data!), nil)
                }
				
			}
		}.resume()
	}
}