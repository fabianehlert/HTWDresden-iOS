import UIKit

public class ViewController: UIViewController {

	public var router: Router?

	public init(router: Router?) {
		self.router = router
		super.init(nibName: nil, bundle: nil)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override public func viewDidLoad() {
		super.viewDidLoad()
	}

	public override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
		super.dismissViewControllerAnimated(flag, completion: completion)
		router?.currentController = nil
	}
}

public extension UIViewController {

	/**
	 Returns a navigation controller with the caller wrapped inside.

	 - returns: navigation controller instance
	 */
	public func wrapInNavigationController() -> UINavigationController {

		// if we already are part of a navigation controller, we return immediatly
		if let n = navigationController {
			return n
		}

		return UINavigationController(rootViewController: self)
	}
}
