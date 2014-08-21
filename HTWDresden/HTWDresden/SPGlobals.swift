//
//  SPGlobals.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation

let CURR_MATRNR_KEY = "Matrikelnummer"
var CURR_MATRNR: String? {
    get {
        return NSUserDefaults(suiteName: SUITNAME_NSUSERDEFAULTS).objectForKey(CURR_MATRNR_KEY) as? String
    }
    set {
        NSUserDefaults(suiteName: SUITNAME_NSUSERDEFAULTS).setObject(newValue!, forKey: CURR_MATRNR_KEY)
    }
}

let CURR_SEMESTER_KEY = "Semester"
var CURR_SEMESTER: String {
get {
    return NSUserDefaults(suiteName: SUITNAME_NSUSERDEFAULTS).objectForKey(CURR_SEMESTER_KEY) as String
}
set {
    NSUserDefaults(suiteName: SUITNAME_NSUSERDEFAULTS).setObject(newValue, forKey: CURR_SEMESTER_KEY)
}
}

let XML_PARSER_URL = "http://www2.htw-dresden.de/~rawa/cgi-bin/auf/raiplan_app.php"