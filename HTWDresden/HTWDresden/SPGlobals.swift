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
        return userDefaults.objectForKey(CURR_MATRNR_KEY) as! String!
    }
    set {
        if newValue != nil {
            userDefaults.setObject(newValue, forKey: CURR_MATRNR_KEY)
        }
        else {
            userDefaults.removeObjectForKey(CURR_MATRNR_KEY)
        }
        userDefaults.synchronize()
    }
}

let CURR_SEMESTER_KEY = "Semester"
var CURR_SEMESTER: String {
get {
    return userDefaults.objectForKey(CURR_SEMESTER_KEY) as! String
}
set {
    userDefaults.setObject(newValue, forKey: CURR_SEMESTER_KEY)
    userDefaults.synchronize()
}
}

let ANZ_LANDSCAPE_KEY = "AnzahlLandscape"
var ANZ_LANDSCAPE: Int {
get {
    return userDefaults.integerForKey(ANZ_LANDSCAPE_KEY)
}
set {
    userDefaults.setInteger(newValue, forKey: ANZ_LANDSCAPE_KEY)
    NSUserDefaults.standardUserDefaults().synchronize()
}
}

let ANZ_PORTRAIT_KEY = "AnzahlPortrait"
var ANZ_PORTRAIT: Int {
get {
    return userDefaults.integerForKey(ANZ_PORTRAIT_KEY)
}
set {
    userDefaults.setInteger(newValue, forKey: ANZ_PORTRAIT_KEY)
    userDefaults.synchronize()
}
}

let XML_PARSER_URL = "http://www2.htw-dresden.de/~rawa/cgi-bin/auf/raiplan_app.php"