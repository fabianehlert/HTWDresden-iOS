//
//  AppDelegate.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 04/03/16.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	let container = ApplicationContainer()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow()

		let g = GradesModule()
		container.registerModule(g)

		let m = MensaModule()
		container.registerModule(m)

		window?.rootViewController = TabbarController(items: container.sortedModules )
		window?.makeKeyAndVisible()

		return true
	}
}

