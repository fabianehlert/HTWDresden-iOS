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

	public func registerModule(module: Module) {
	}

	public func registerRoute<T: Route>(route: T, module: Module, handler: RoutingParameter -> Void) {
	}

	public func route<T: Route>(route: T, parameter: RoutingParameter) {
	}
}