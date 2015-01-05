//
//  NPGlobals.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 29.10.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation

private let SNUMMER_KEY = "S-Nummer"
var SNUMMER: String! {
get {
    return userDefaults.objectForKey(SNUMMER_KEY) as String!
}
set {
    if newValue != nil {
        userDefaults.setObject(newValue, forKey: SNUMMER_KEY)
    }
    else {
        userDefaults.removeObjectForKey(SNUMMER_KEY)
    }
    userDefaults.synchronize()
}
}

private let RZLOGIN_KEY = "RZ-Login"
var RZLOGIN: String {
get {
    return userDefaults.objectForKey(RZLOGIN_KEY) as String
}
set {
    userDefaults.setObject(newValue, forKey: RZLOGIN_KEY)
    userDefaults.synchronize()
}
}