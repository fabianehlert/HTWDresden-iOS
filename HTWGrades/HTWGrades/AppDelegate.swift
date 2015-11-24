//
//  AppDelegate.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 23/11/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		window = UIWindow()
		
		let controller = GradesListViewController()
		let navigationController = UINavigationController(rootViewController: controller)
		
		window?.rootViewController =  navigationController
		
		window?.makeKeyAndVisible()
		
		
		return true
	}

}

