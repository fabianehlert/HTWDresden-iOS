import UIKit
import Kingfisher

class MealDetailViewController: UIViewController {
	var tableView = UITableView()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.frame = view.bounds
		tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		tableView.delegate = self
		tableView.dataSource = self

		tableView.registerClass(MealDetailViewCell.self, forCellReuseIdentifier: "cell")

		view.addSubview(tableView)
	}
}

extension MealDetailViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
	}
}