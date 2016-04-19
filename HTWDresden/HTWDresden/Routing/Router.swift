import UIKit

public typealias RouteURL = String

public protocol Module {
	var name: String { get }
	var image: UIImage { get }

	var initialController: UIViewController { get }
}

public protocol Route: RawRepresentable { }

public class ApplicationContainer {
	private var names = [String]()
	private var modules = [String: Module]()

    var sortedModules: [(name: String, module: Module)] {
		return names.map {
			return ($0, modules[$0]!)
		}
	}

	public func registerModule(module: Module) {
		if let index = names.indexOf(module.name) {
			names.removeAtIndex(index)
		}
		modules[module.name] = module
		names.append(module.name)
	}
}