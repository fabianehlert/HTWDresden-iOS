import UIKit

class MealMainViewController: UIViewController {
	var tableView = UITableView()
	var meals = [MensaData]()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.frame = view.bounds
		tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		tableView.delegate = self
		tableView.dataSource = self

		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

		self.view.addSubview(tableView)
	}
}

extension MealMainViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
		cell.textLabel?.text = meals[indexPath.row].strTitle
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let controller = MealDetailViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
}