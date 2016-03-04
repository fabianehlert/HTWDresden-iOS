//
//  AppDelegate.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 04/03/16.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import Core
import HTWGrades

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let router = Router()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow()
        
        let g = GradesModule()
        router.registerModule(g)
        
        window?.rootViewController = g.initialController
        window?.makeKeyAndVisible()
        
        return true
    }
}

