//
//  GradesModule.swift
//  Pods
//
//  Created by Benjamin Herzog on 20/02/16.
//
//

import UIKit

class Settings {
	var userDefaults: NSUserDefaults

	init(userDefaults: NSUserDefaults = .standardUserDefaults()) {
		self.userDefaults = userDefaults
	}

	var sNumber: String? {
		get {
			return userDefaults.objectForKey("sNumber") as? String
		}
		set {
			userDefaults.setObject(newValue, forKey: "sNumber")
		}
	}
	var password: String? {
		get {
			return userDefaults.objectForKey("password") as? String
		}
		set {
			userDefaults.setObject(newValue, forKey: "password")
		}
	}
}

public class GradesModule: Module {
	public init() { }

	public static var shared = GradesModule()

	public var router: Router?

	public var name: String { return "Noten" }
	public var image: UIImage { return UIImage() }

	public var initialController: UIViewController { return GradesListViewController(router: router).wrapInNavigationController() }

	var settings = Settings()
}