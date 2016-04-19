import UIKit

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
