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

	let router = Router()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow()

		let g = GradesModule()
		router.registerModule(g)

		let m = MensaModule()
		router.registerModule(m)

		let tabbar = UITabBarController()
		tabbar.viewControllers = router.modules.map { $0.1.initialController }

		window?.rootViewController = TabbarController(items: router.modules.map { $0 })
		window?.makeKeyAndVisible()

		return true
	}
}

