import UIKit

public class MensaModule: Module {
	public init() { }

	public static var shared = MensaModule()

	public var name: String { return "Mensa" }
	public var image: UIImage { return UIImage() }

	public var initialController: UIViewController { return MensaMainViewController(collectionViewLayout: UICollectionViewFlowLayout()).wrapInNavigationController() }
}
