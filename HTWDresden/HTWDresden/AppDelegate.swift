//
//  AppDelegate.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 04/03/16.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import Core
import Grades
import Lesson
import Mensa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	let router = Router()
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		window = UIWindow()
		
		let g = GradesModule()
		router.registerModule(g)
		
		let l = LessonsModule()
		router.registerModule(l)
		
		let m = MensaModule()
		router.registerModule(m)
		
		window?.rootViewController = m.initialController
		window?.makeKeyAndVisible()
		
		return true
	}
}

