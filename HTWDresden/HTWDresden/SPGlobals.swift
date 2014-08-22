//
//  SPGlobals.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation


let CURR_MATRNR_KEY = "Matrikelnummer"
var CURR_MATRNR: String! {
    get {
        return NSUserDefaults.standardUserDefaults().objectForKey(CURR_MATRNR_KEY) as String!
    }
    set {
        if newValue != nil {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: CURR_MATRNR_KEY)
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(CURR_MATRNR_KEY)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

let CURR_SEMESTER_KEY = "Semester"
var CURR_SEMESTER: String {
get {
    return NSUserDefaults.standardUserDefaults().objectForKey(CURR_SEMESTER_KEY) as String
}
set {
    NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: CURR_SEMESTER_KEY)
    NSUserDefaults.standardUserDefaults().synchronize()
}
}

let ANZ_LANDSCAPE_KEY = "AnzahlLandscape"
var ANZ_LANDSCAPE: Int {
get {
    return NSUserDefaults.standardUserDefaults().integerForKey(ANZ_LANDSCAPE_KEY)
}
set {
    NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: ANZ_LANDSCAPE_KEY)
    NSUserDefaults.standardUserDefaults().synchronize()
}
}

let ANZ_PORTRAIT_KEY = "AnzahlPortrait"
var ANZ_PORTRAIT: Int {
get {
    return NSUserDefaults.standardUserDefaults().integerForKey(ANZ_PORTRAIT_KEY)
}
set {
    NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: ANZ_PORTRAIT_KEY)
    NSUserDefaults.standardUserDefaults().synchronize()
}
}

let XML_PARSER_URL = "http://www2.htw-dresden.de/~rawa/cgi-bin/auf/raiplan_app.php"