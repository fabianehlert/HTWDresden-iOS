//
//  MPGlobals.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 27.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation

var CURR_MENSA: String! {
    get{ return NSUserDefaults.standardUserDefaults().objectForKey("CURR_MENSA") as String! }
    set{
        if newValue != nil {
            userDefaults.setObject(newValue, forKey: "CURR_MENSA")
        }
        else {
            userDefaults.removeObjectForKey("CURR_MENSA")
        }
        userDefaults.synchronize()
    }
}

var MENSA_LAST_REFRESH: NSDate! {
    get{ return userDefaults.objectForKey("MENSA_LAST_REFRESH") as NSDate! }
    set{ if newValue != nil {
            userDefaults.setObject(newValue, forKey: "MENSA_LAST_REFRESH")
        }
        else {
            userDefaults.removeObjectForKey("MENSA_LAST_REFRESH")
            }
            userDefaults.synchronize() }
    }

let MENSA_URL = "http://www.studentenwerk-dresden.de/feeds/speiseplan.rss"