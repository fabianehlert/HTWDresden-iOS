//
//  AppDelegate.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 02/20/2016.
//  Copyright (c) 2016 Benjamin Herzog. All rights reserved.
//

import UIKit
import HTWGrades

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		window = UIWindow()

		let module = GradesModule.shared
		window?.rootViewController = module.initialController
		window?.makeKeyAndVisible()

		return true
	}
}
