import UIKit

public typealias RouteURL = String

public protocol Module {
	var router: Router? { get set }

	var name: String { get }
	var image: UIImage { get }

	var initialController: UIViewController { get }
}

public protocol Route: RawRepresentable { }

public class Router {
	var currentController: ViewController?

	public typealias RoutingParameter = [String: AnyObject]

	private(set) var modules = [String: Module]()

	public func registerModule(module: Module) {
		modules[module.name] = module
	}

	public func registerRoute<T: Route>(route: T, module: Module, handler: RoutingParameter -> Void) {
	}

	public func route<T: Route>(route: T, parameter: RoutingParameter) {
	}
}