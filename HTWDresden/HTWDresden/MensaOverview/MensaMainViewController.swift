import UIKit

let getMensa = "http://www.studentenwerk-dresden.de/feeds/speiseplan.rss"
let margin: CGFloat = 8

class MensaMainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	let identifier = "cell"

	let layout = UICollectionViewFlowLayout()
	var mensaData: [(name: String, meals: [MensaData])] = []

	override func viewDidLoad() {
		self.title = "Mensa"

		super.viewDidLoad()
		collectionView?.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)

		collectionView?.registerClass(MensaMainCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
		collectionView?.alwaysBounceVertical = true
		collectionView?.pagingEnabled = true

		collectionView?.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)

		let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		activityView.center = view.center
		view.addSubview(activityView)
		activityView.hidesWhenStopped = true
		activityView.startAnimating()

		let p = Parser(strPath: getMensa)
		p.loadData() {
			result in
			self.mensaData = result.map { $0 }.sort { $0.0 < $1.0 }
			activityView.stopAnimating()
			self.collectionView?.reloadData()
		}
	}

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return mensaData.count
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
	}

	override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		if let cell = cell as? MensaMainCollectionViewCell {
			cell.mensa = mensaData[indexPath.row].name
		}
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: (collectionView.bounds.size.width - margin * 3) / 2 - 2, height: 50)
	}

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		collectionView.deselectItemAtIndexPath(indexPath, animated: true)
		let controller = MealMainViewController()
		controller.meals = mensaData[indexPath.row].meals
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
